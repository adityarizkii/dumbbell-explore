//
//  PoseDetectionViewModel.swift
//  vision-explore
//
//  Created by Aditya Rizki on 28/05/25.
//

import Foundation
import Vision
import SwiftUI
import CoreGraphics
import CoreVideo

class PoseDetectionViewModelTrial: PoseDetectionViewModel {
    
    
    private let sequenceHandler = VNSequenceRequestHandler()
    private var jointsCaptured = false
    

    
    enum position {
        case right
        case left
    }
    
 
    
    
    
 
    
 
    private let timingTolerance: TimeInterval = 0.5
    
    private var isInUpPosition: Bool = false
    private var isInDownPosition: Bool = false
    private var phaseStartTime: Date?
    private var currentPhase: ExercisePhase = .none
    private var currentUpDuration: TimeInterval = 0
    private var currentDownDuration: TimeInterval = 0
    private var isAddingRepetition: Bool = false
    
    
    enum ExercisePhase {
        case none
        case lifting
        case lowering
    }
    
    
    override func angleBetweenPoints(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGFloat {
//        let s = currentPoints?[VNHumanBodyPoseObservation.JointName.leftWrist]?.x ?? 0
        let vectorBA = CGVector(dx: pointA.x - pointB.x, dy: pointA.y - pointB.y)
        let vectorBC = CGVector(dx: pointC.x - pointB.x, dy: pointC.y - pointB.y)
        
        let dotProduct = vectorBA.dx * vectorBC.dx + vectorBA.dy * vectorBC.dy
        let magnitudeBA = sqrt(vectorBA.dx * vectorBA.dx + vectorBA.dy * vectorBA.dy)
        let magnitudeBC = sqrt(vectorBC.dx * vectorBC.dx + vectorBC.dy * vectorBC.dy)
        
        guard magnitudeBA > 0, magnitudeBC > 0 else { return 0 }
        
        let cosineAngle = dotProduct / (magnitudeBA * magnitudeBC)
        let clampedCosine = min(1, max(-1, cosineAngle))
        
        let angleRadians = acos(clampedCosine)
        return angleRadians * 180 / .pi
    }
    
    override func processFrame(pixelBuffer: CVPixelBuffer) {
        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard let self = self else { return }
            guard let observations = request.results as? [VNHumanBodyPoseObservation],
                  let first = observations.first else {
                DispatchQueue.main.async {
                    self.feedbackText = "Get on the Frame"
                    self.currentPoints = nil
                    self.overlayColor = .gray
                }
                return
            }
            
            
            do {
                let jointPoints = try first.recognizedPoints(.rightArm)
                
                if !self.jointsCaptured {
                    self.captureArmJoints(jointPoints: jointPoints)

                }
                
                print("mulai : \(self.mulai)")
                
                self.checkPosition(points: jointPoints)
                
                if self.mulai{
                    self.evaluatePose(points: jointPoints)
                }
                
//                self.evaluatePose(points: jointPoints)
            } catch {
                print("Error: \(error)")
            }
        }
        
        do {
            try sequenceHandler.perform([request], on: pixelBuffer)
        } catch {
            print("Failed request: \(error)")
        }
    }
    
    private func captureArmJoints(position : position = .right ,  jointPoints: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
    
        let shoulderPos:VNHumanBodyPoseObservation.JointName = position == .left ? .leftShoulder : .rightShoulder
        let elbowPos:VNHumanBodyPoseObservation.JointName = position == .left ? .leftElbow :.rightElbow
        let wristPos:VNHumanBodyPoseObservation.JointName = position == .left ? .leftWrist :.rightWrist
        
        if let shoulder = jointPoints[shoulderPos],
           let elbow = jointPoints[elbowPos],
           let wrist = jointPoints[wristPos],
           shoulder.confidence > 0.5,
           elbow.confidence > 0.5,
           wrist.confidence > 0.5 {

            // Record the first detected right arm joints
            let shoulderPoint = CGPoint(x: CGFloat(1 - shoulder.location.y), y: CGFloat(shoulder.location.x))
            let elbowPoint = CGPoint(x: CGFloat(1 - elbow.location.y), y: CGFloat(elbow.location.x))
            let wristPoint = CGPoint(x: CGFloat(1 - wrist.location.y), y: CGFloat(wrist.location.x))
            
            // Append to capturedJoints array
            capturedJoints.append((shoulder: shoulderPoint, elbow: elbowPoint, wrist: wristPoint))
            jointsCaptured = true
//            print("Captured right arm joints shoulder : \(capturedJoints[0].shoulder.x) , \(capturedJoints[0].shoulder.y)")
//            print("Captured right arm joints elbow : \(capturedJoints[0].elbow.x) , \(capturedJoints[0].elbow.y)")
//            print("Captured right arm joints wrist : \(capturedJoints[0].wrist.x) , \(capturedJoints[0].wrist.y)")
        }
    }
    
    private func evaluateDumbbellCurl(angle: CGFloat) -> (String, Color) {
        let currentTime = Date()
        
        // Update exercise phase
        if angle < config.downAngle {
            if currentPhase != .lowering {
                currentPhase = .lowering
                phaseStartTime = nil  // Reset timer when starting to move
//                print("Reset timer - starting lowering phase")
            }
            isInDownPosition = true
            isInUpPosition = false  // Reset isInUpPosition when starting to lower
//            print("Phase: Lowering, isInUpPosition: \(isInUpPosition), isInDownPosition: \(isInDownPosition)")
            
            return ("Turunkan dumbbell", .red)
            
        } else if angle > config.upAngle {
            if currentPhase != .lifting {
                currentPhase = .lifting
                phaseStartTime = nil  // Reset timer when starting to move
//                print("Reset timer - starting lifting phase")
            }
            isInUpPosition = true
//            print("Phase: Lifting, isInUpPosition: \(isInUpPosition), isInDownPosition: \(isInDownPosition)")
            
            if isAddingRepetition {
//                print("Adding repetition! Current count: \(repetitionCount)")
                let data = RepetitionData(
                    number: repetitionCount + 1,
                    upDuration: currentUpDuration,
                    downDuration: currentDownDuration
                )
                repetitionData.append(data)
                
                repetitionCount += 1
                isInDownPosition = false
                isInUpPosition = false  // Reset both flags after completing repetition
                currentPhase = .none
                phaseStartTime = nil  // Reset timer after completing repetition
                currentUpDuration = 0
                currentDownDuration = 0
                isAddingRepetition = false
//                print("Reset timer - completed repetition")
                
                if repetitionCount >= config.repetition {
                    DispatchQueue.main.async {
                        self.showCompletionAlert = true
                    }
                }
            }

            return ("Angkat dumbbell", .yellow)
        } else {
            // Start timing when position is correct (green)
            if phaseStartTime == nil {
                phaseStartTime = currentTime
//                print("Start timing - position is correct")
            }
            
            if let startTime = phaseStartTime {
                let duration = currentTime.timeIntervalSince(startTime)
                
                // Update current duration based on phase
                if currentPhase == .lifting {
                    currentUpDuration = duration
//                    print("Up duration: \(duration)")
                } else if currentPhase == .lowering {
                    currentDownDuration = duration
//                    print("Down duration: \(duration)")
                    isAddingRepetition = true
                }
                
                let targetDuration = currentPhase == .lifting ? config.timeUp : config.timeDown
                let timeFeedback = getTimingFeedback(duration: duration, targetDuration: targetDuration)
                return ("Gerakan bagus! (\(String(format: "%.1f", duration))s) - \(timeFeedback)", .green)
            }
            
            return ("Gerakan bagus!", .green)
        }
    }
    
    private func getTimingFeedback(duration: TimeInterval, targetDuration: TimeInterval) -> String {
        let difference = abs(duration - targetDuration)
        if difference <= timingTolerance {
            return "Tempo tepat!"
        } else if duration < targetDuration {
            return "Lebih lambat"
        } else {
            return "Lebih cepat"
        }
    }
    
    override func resetExercise() {
        repetitionCount = 0
        isInUpPosition = false
        isInDownPosition = false
        showCompletionAlert = false
        repetitionData.removeAll()
        currentUpDuration = 0
        currentDownDuration = 0
    }
    
    private func checkPosition(points: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]){
        DispatchQueue.main.async {
            self.currentPoints = points
            let rightShoulder = points[.rightShoulder]
            let rightElbow = points[.rightElbow]
            let rightWrist = points[.rightWrist]
            
            self.wristJoint = CGPoint(x: rightWrist?.x ?? 0, y: rightWrist?.y ?? 0)

            
            func getDistance() -> Double{
                return distanceBetween(CGPoint(x :( rightElbow?.x ?? 0 ) , y : ( rightElbow?.y ?? 0 ) ),CGPoint(x :( rightWrist?.x ?? 0 ) , y : ( rightWrist?.y ?? 0 ) ))
            }
            
//            print("Posisi lengan kanan \( getDistance())")
//            print("Posisi Shulder kanan \(  rightShoulder?.x ?? 0  ) \(  rightShoulder?.y ?? 0  )")
//            print("Posisi elbow kanan \(   rightElbow?.x ?? 0  ) \(  rightElbow?.y ?? 0  )")
//            print( "Posisi Wrist kanan \(  rightWrist?.x ?? 0  ) \(  rightWrist?.y ?? 0  )")

            
            
            if (  rightShoulder?.x ?? 0  ) > 0.2 , (  rightWrist?.x ?? 0  ) < 0.7 {
                print("OKKKKEEEE")
                self.updateFeedback("POSISI OKEEEEE")
                self.mulai = true
            }
            
//            if getDistance() > 0.1 && getDistance() < 0.4 && (rightElbow?.x ?? 0) > 0.2 && (rightElbow?.x ?? 0 ) < 0.4 {
//                print("OKKKKEEEE")
//                self.feedbackText = "POSISI OKKEEEE"
//                self.mulai = true
//            }
            
//            self.mulai = true
//            print(self.mulai)
        }
        
    }
    
    private func evaluatePose(points: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
        DispatchQueue.main.async {
            self.currentPoints = points
            
            // Check if we have right arm points
            let hasrightArm = points[.rightShoulder] != nil &&
                             points[.rightElbow] != nil &&
                             points[.rightWrist] != nil
            
            guard hasrightArm else {
                self.updateFeedback("Tidak ada pose terdeteksi !")
                self.currentPoints = nil
                self.overlayColor = .gray
                return
            }
            
            
            
            
            
            
            // Get right arm points
            let rightShoulder = points[.rightShoulder]
            let rightElbow = points[.rightElbow]
            let rightWrist = points[.rightWrist]
            
//            func getDistance() -> Double{
//                return distanceBetween(CGPoint(x :( rightElbow?.x ?? 0 ) , y : ( rightElbow?.y ?? 0 ) ),CGPoint(x :( rightWrist?.x ?? 0 ) , y : ( rightWrist?.y ?? 0 ) ))
//            }
//
//            print("Posisi lengan kanan \( getDistance())")
//
//
//
//            if getDistance() < 0.1 {
//                self.feedbackText = "POSISIKAN DIRI MENDEKAT KE KAMERA"
//                self.currentPoints = nil
//                self.overlayColor = .gray
//
//                return
//            }
//
//            if getDistance() > 0.4 {
//                self.feedbackText = "POSISIKAN DIRI MENJAUH DARI KAMERA"
//                self.currentPoints = nil
//                self.overlayColor = .gray
//                return
//            }
//
//            if (rightElbow?.x ?? 0) < 0.4 || (rightElbow?.x ?? 0 ) > 0.6 {
//                self.feedbackText = "POSISIKAN DIRI DITENGAH KAMERA"
//                self.currentPoints = nil
//                self.overlayColor = .gray
//                return
//            }
//
//            self.mulai = true
            
//            print("rightShoulder \(rightShoulder),rightElbow \(rightElbow),rightWrist \(rightWrist)")
            
            // print("Confident: \(rightShoulder?.confidence ?? 0), \(rightElbow?.confidence ?? 0), \(rightWrist?.confidence ?? 0)")
            
            // Check for right arm detection with confidence threshold
            let rightArmDetected = rightShoulder?.confidence ?? 0 > 0.1 &&
                                 rightElbow?.confidence ?? 0 > 0.1 &&
                                 rightWrist?.confidence ?? 0 > 0.1
            
            guard rightArmDetected else {
                self.updateFeedback("Pose tidak jelas !")
                self.overlayColor = .gray
                return
            }
            
            let convertPoint: (VNRecognizedPoint) -> CGPoint = { point in
                CGPoint(x: CGFloat(point.location.x), y: CGFloat(1 - point.location.y))
            }
            
            if let rightWristPt = rightWrist.map(convertPoint),
               let rightElbowPt = rightElbow.map(convertPoint),
               let rightShoulderPt = rightShoulder.map(convertPoint) {
                let rightAngle = self.angleBetweenPoints(pointA: rightWristPt, pointB: rightElbowPt, pointC: rightShoulderPt)
                // print("right Angle: \(rightAngle)")
                
                let (feedback, color) = self.evaluateDumbbellCurl(angle: rightAngle)
                //self.updateFeedback( "\(feedback) \n\(Int(rightAngle))°- Rep: \(self.repetitionCount)/\(self.config.repetition)")
                self.overlayColor = color
            }
        }
    }
}
