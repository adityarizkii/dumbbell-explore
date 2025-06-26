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

class PoseDetectionViewModel: NSObject, ObservableObject {
    
    
    @Published var feedbackText: String = ""
    @Published var currentPoints: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]? = nil
    @Published var overlayColor: Color = .gray
    @Published var showCompletionAlert: Bool = false
    @Published var repetitionCount: Int = 0
    @Published var repetitionData: [RepetitionData] = []
    public var config: ExerciseAttribute = curl
    
    @Published var mulai: Bool = false
    @Published var is90degree: Bool = false
    @Published var showArmArea: Bool = false
    
    private let sequenceHandler = VNSequenceRequestHandler()
    private var jointsCaptured = false
    
    @State private var currentSide: position = .right
    
    var capturedJoints: [(shoulder: CGPoint, elbow: CGPoint, wrist: CGPoint)] = []
    
    enum position {
        case right
        case left
    }
    
    var firstJoint: (shoulder: CGPoint, elbow: CGPoint, wrist: CGPoint)? {
        capturedJoints.first
    }
    
    
    struct RepetitionData {
        
        let number: Int
        let upDuration: TimeInterval
        let downDuration: TimeInterval
        
        var upFeedback: String {
            let difference = abs(upDuration - 2.0)
            if difference <= 0.5 {
                return "Pas"
            } else if upDuration < 2.0 {
                return "Terlalu Cepat"
            } else {
                return "Terlalu Lambat"
            }
        }
        
        var downFeedback: String {
            let difference = abs(downDuration - 3.0)
            if difference <= 0.5 {
                return "Pas"
            } else if downDuration < 3.0 {
                return "Terlalu Cepat"
            } else {
                return "Terlalu Lambat"
            }
        }
    }
    
    
    
    
    private let timingTolerance: TimeInterval = 0.5
    
    private var isInUpPosition: Bool = false
    private var isInDownPosition: Bool = false
    private var phaseStartTime: Date?
    private var currentPhase: ExercisePhase = .none
    private var currentUpDuration: TimeInterval = 0
    private var currentDownDuration: TimeInterval = 0
    private var isAddingRepetition: Bool = false
    @Published var wristJoint : CGPoint?
    
    
    
    
    enum ExercisePhase {
        case none
        case lifting
        case lowering
    }
    
    func angleBetweenPoints(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGFloat {
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
    
    func processFrame(pixelBuffer: CVPixelBuffer) {
        let request = VNDetectHumanBodyPoseRequest { [weak self] request, error in
            guard let self = self else { return }
            guard let observations = request.results as? [VNHumanBodyPoseObservation],
                  let first = observations.first else {
                DispatchQueue.main.async {
                    //                    self.feedbackText = "Get on the Frame"
                    self.currentPoints = nil
                    self.overlayColor = .gray
                }
                return
            }
            
            
            //            print("90 DEGREE : \(self.is90degree)")
            //            print("show arms area : \(self.showArmArea)")
            print("mulai : \(self.mulai)")
            
            
            do {
                let jointPoints = try first.recognizedPoints(.all)
                
                // Retrieve the positions of the left and right shoulders
//                guard let leftShoulder = jointPoints[.leftShoulder],
//                      let rightShoulder = jointPoints[.rightShoulder] else {
//                    DispatchQueue.main.async {
//                        self.feedbackText = "Shoulder joints not detected"
//                    }
//                    return
//                }
                
                //                // Calculate the difference in the x and y coordinates of the shoulders
                //                let xDiff = abs(leftShoulder.location.x - rightShoulder.location.x)
                //                let yDiff = abs(leftShoulder.location.y - rightShoulder.location.y)
                //
                //                // Set a tolerance for error (the threshold for being considered aligned)
                //                let tolerance: CGFloat = 0.1  // Allow a little tolerance for error in alignment
                //
                //                // Check if both shoulders are close to each other on the x-axis (indicating a 90-degree alignment)
                //                if xDiff < tolerance && yDiff < tolerance {
                //                    DispatchQueue.main.async {
                //                        self.is90degree = true
                //                        self.showArmArea = true
                //                        self.overlayColor = .green
                //                    }
                //                } else {
                //                    DispatchQueue.main.async {
                //                                                self.feedbackText = "Body is not aligned at 90 degrees"
                //
                //                        self.overlayColor = .red
                //                    }
                //                }
                
                if !self.is90degree {
                    DispatchQueue.main.async {
                        self.getAngleBody(jointPoints: jointPoints)
                    }
                }
                
                if self.is90degree && !self.jointsCaptured {
                    DispatchQueue.main.async {
                        // Ensure we check arm position first
                        self.checkPosition(points: jointPoints)
                    }
                }
                
                // After position is checked, if it's correct, capture the joints
                if self.is90degree && self.showArmArea == false && !self.jointsCaptured {
                    DispatchQueue.main.async {
                        self.captureArmJoints(jointPoints: jointPoints)
                    }
                }
                
                if mulai {
                    DispatchQueue.main.async {
                        self.evaluatePose(points: jointPoints)
                    }
                }
                
                
                //                if !self.jointsCaptured {
                //                    DispatchQueue.main.async {
                //                        self.captureArmJoints(jointPoints: jointPoints)
                //                    }
                //                }
                //
                //                print("is really captured  ??: \(self.jointsCaptured)")
                //                //
                //                self.checkPosition(points: jointPoints)
                //
                //
                //
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
    
    private func getAngleBody(jointPoints: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]){
        let rightshoulderPos:VNHumanBodyPoseObservation.JointName =  .rightShoulder
        //        let rightelbowPos:VNHumanBodyPoseObservation.JointName = .rightElbow
        //        let rightwristPos:VNHumanBodyPoseObservation.JointName = .rightWrist
        let leftshoulderPos:VNHumanBodyPoseObservation.JointName =  .leftShoulder
        //        let leftelbowPos:VNHumanBodyPoseObservation.JointName = .leftElbow
        //        let leftwristPos:VNHumanBodyPoseObservation.JointName = .leftWrist
        
        let rightShoulder = jointPoints[rightshoulderPos]!
        let leftShoulder = jointPoints[leftshoulderPos]!
        let xDiff = abs(leftShoulder.location.x - rightShoulder.location.x)
        let yDiff = abs(leftShoulder.location.y - rightShoulder.location.y)
        
        print("X DIFF : \(leftShoulder.location.x) - \(rightShoulder.location.x)")
        print("Y DIFF : \(leftShoulder.location.y) - \(rightShoulder.location.y)")
        
        let tolerance: CGFloat = 0.05
        
        if xDiff < tolerance && yDiff < tolerance {
            DispatchQueue.main.async {
                self.is90degree = true
                self.showArmArea = true
                self.overlayColor = .green
            }
        } else {
            DispatchQueue.main.async {
                //                self.feedbackText = "Body is not aligned at 90 degrees"
                
//                self.overlayColor = .red
            }
        }
    }
    
    private func captureArmJoints(position : position = .right , jointPoints: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
        
        let shoulderPos:VNHumanBodyPoseObservation.JointName = position == .left ? .leftShoulder : .rightShoulder
        let elbowPos:VNHumanBodyPoseObservation.JointName = position == .left ? .leftElbow :.rightElbow
        let wristPos:VNHumanBodyPoseObservation.JointName = position == .left ? .leftWrist :.rightWrist
        
//        let rightshoulderPos:VNHumanBodyPoseObservation.JointName =  .rightShoulder
//        let rightelbowPos:VNHumanBodyPoseObservation.JointName = .rightElbow
//        let rightwristPos:VNHumanBodyPoseObservation.JointName = .rightWrist
//        let leftshoulderPos:VNHumanBodyPoseObservation.JointName =  .leftShoulder
//        let leftelbowPos:VNHumanBodyPoseObservation.JointName = .leftElbow
//        let leftwristPos:VNHumanBodyPoseObservation.JointName = .leftWrist
//        
//        
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
            self.capturedJoints.append((shoulder: shoulderPoint, elbow: elbowPoint, wrist: wristPoint))
            self.jointsCaptured = true
            print("Captured arm joints shoulder : \(self.capturedJoints[0].shoulder.x) , \(self.capturedJoints[0].shoulder.y)")
            print("Captured arm joints elbow : \(self.capturedJoints[0].elbow.x) , \(self.capturedJoints[0].elbow.y)")
            print("Captured arm joints wrist : \(self.capturedJoints[0].wrist.x) , \(self.capturedJoints[0].wrist.y)")
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
    
    func resetExercise() {
        repetitionCount = 0
        isInUpPosition = false
        isInDownPosition = false
        showCompletionAlert = false
        repetitionData.removeAll()
        currentUpDuration = 0
        currentDownDuration = 0
        mulai = false
        is90degree = false
        showArmArea = false
        jointsCaptured = false
        
        
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
            //                        print("Posisi Shulder kanan \(  rightShoulder?.x ?? 0  ) \(  rightShoulder?.y ?? 0  )")
            //            print("Posisi elbow kanan \(   rightElbow?.x ?? 0  ) \(  rightElbow?.y ?? 0  )")
            //            print( "Posisi Wrist kanan \(  rightWrist?.x ?? 0  ) \(  rightWrist?.y ?? 0  )")
            
            
            
            //            if (  rightShoulder?.x ?? 0  ) > 0.2 , (  rightWrist?.x ?? 0  ) < 0.7 {
            //                print("OKKKKEEEE")
            //                self.feedbackText = "POSISI OKKEEEE"
            //                self.mulai = true
            //                self.showArmArea = false
            //            }
            
            // Extract the x-coordinates of the joints
            let shoulderX = 1-(  rightShoulder?.y ?? 0  )
            let elbowX = 1-(  rightElbow?.y ?? 0  )
            let wristX = 1-(  rightWrist?.y ?? 0  )
            
            print("jarak sumbu x : \(shoulderX)")
            
            if !self.mulai{
                if round(shoulderX * 100) / 100 <= 0.70 {
                    DispatchQueue.main.async {
                        self.feedbackText = "Move backward to Center of Yellow area"
                    }
                } else if round(shoulderX * 100) / 100 >= 0.78 {
                    DispatchQueue.main.async {
                        self.feedbackText = "Move forward to Center of Yellow area."
                        print(shoulderX)
                    }
                }else {
//                    DispatchQueue.main.async {
//                        self.feedbackText = "Adjust your arm"
//                    }
//                    Move closer to the camera.
//                    Move away from the camera
                    
                    
                    // Calculate the differences in the x-axis between the joints
                    
                    let shoulderElbowDiff = abs(shoulderX - elbowX)
                    let elbowWristDiff = abs(elbowX - wristX)
                    
                    // Set a tolerance for error (the threshold for being considered aligned)
                    let tolerance: CGFloat = 0.05  // Allow a little tolerance for error in vertical alignment
                    
                    // Check if all joints are aligned vertically (within the tolerance on the x-axis)
                    if shoulderElbowDiff < tolerance && elbowWristDiff < tolerance {
                        DispatchQueue.main.async {
                            self.overlayColor = .green // Set overlay color to green when aligned
                            self.feedbackText = "Good Position!"
                            self.showArmArea = false
                            self.mulai = true
                        }
                    }
                    
                    
                    return
                    
                }
                
                
    //            else {
    //                DispatchQueue.main.async {
    //                    self.overlayColor = .red // Set overlay color to red when not aligned
    //                    self.showArmArea = false
    //                }
    //            }
                
                
            }

            
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
                self.feedbackText = "Tidak ada pose terdeteksi"
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
                self.feedbackText = "Pose tidak jelas"
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
                self.feedbackText = "\(feedback) \n\(Int(rightAngle))°- Rep: \(self.repetitionCount)/\(self.config.repetition)"
                self.overlayColor = color
            }
        }
    }
}
