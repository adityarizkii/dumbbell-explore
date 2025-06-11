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

class PoseDetectionViewModel: NSObject, ObservableObject {
    @Published var feedbackText: String = ""
    @Published var currentPoints: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]? = nil
    @Published var overlayColor: Color = .gray
    @Published var showCompletionAlert: Bool = false
    @Published var repetitionCount: Int = 0
    @Published var repetitionData: [RepetitionData] = []
    
    private let sequenceHandler = VNSequenceRequestHandler()
    
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
    
    // Constants for dumbbell curl exercise
    private let curlUpAngle: CGFloat = 135.0    // Angle threshold for curl up position
    private let curlDownAngle: CGFloat = 65.0   // Angle threshold for curl down position
    private let maxRepetitions: Int = 5
    
    // Timing constants
    private let targetUpDuration: TimeInterval = 2.0    // 2 seconds for lifting
    private let targetDownDuration: TimeInterval = 3.0  // 3 seconds for lowering
    private let timingTolerance: TimeInterval = 0.5     // 0.5 seconds tolerance
    
    // State for tracking exercise phase
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
    
    func angleBetweenPoints(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGFloat {
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
                    self.feedbackText = "Tidak ada pose terdeteksi"
                    self.currentPoints = nil
                    self.overlayColor = .gray
                }
                return
            }
            
            do {
                let jointPoints = try first.recognizedPoints(.all)
                self.evaluatePose(points: jointPoints)
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
    
    private func evaluateDumbbellCurl(angle: CGFloat) -> (String, Color) {
        let currentTime = Date()
        
        // Update exercise phase
        if angle < curlDownAngle {
            if currentPhase != .lowering {
                currentPhase = .lowering
                phaseStartTime = nil  // Reset timer when starting to move
                print("Reset timer - starting lowering phase")
            }
            isInDownPosition = true
            isInUpPosition = false  // Reset isInUpPosition when starting to lower
            print("Phase: Lowering, isInUpPosition: \(isInUpPosition), isInDownPosition: \(isInDownPosition)")
            
            return ("Turunkan dumbbell", .red)
            
        } else if angle > curlUpAngle {
            if currentPhase != .lifting {
                currentPhase = .lifting
                phaseStartTime = nil  // Reset timer when starting to move
                print("Reset timer - starting lifting phase")
            }
            isInUpPosition = true
            print("Phase: Lifting, isInUpPosition: \(isInUpPosition), isInDownPosition: \(isInDownPosition)")
            
            if isAddingRepetition {
                print("Adding repetition! Current count: \(repetitionCount)")
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
                print("Reset timer - completed repetition")
                
                if repetitionCount >= maxRepetitions {
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
                print("Start timing - position is correct")
            }
            
            if let startTime = phaseStartTime {
                let duration = currentTime.timeIntervalSince(startTime)
                
                // Update current duration based on phase
                if currentPhase == .lifting {
                    currentUpDuration = duration
                    print("Up duration: \(duration)")
                } else if currentPhase == .lowering {
                    currentDownDuration = duration
                    print("Down duration: \(duration)")
                    isAddingRepetition = true
                }
                
                let targetDuration = currentPhase == .lifting ? targetUpDuration : targetDownDuration
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
    }
    
    private func evaluatePose(points: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
        DispatchQueue.main.async {
            self.currentPoints = points
            
            // Check if we have right arm points
            let hasRightArm = points[.rightShoulder] != nil && 
                             points[.rightElbow] != nil && 
                             points[.rightWrist] != nil
            
            guard hasRightArm else {
                self.feedbackText = "Tidak ada pose terdeteksi"
                self.currentPoints = nil
                self.overlayColor = .gray
                return
            }
            
            // Get right arm points
            let rightShoulder = points[.rightShoulder]
            let rightElbow = points[.rightElbow]
            let rightWrist = points[.rightWrist]
            
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
                // print("Right Angle: \(rightAngle)")
                
                let (feedback, color) = self.evaluateDumbbellCurl(angle: rightAngle)
                self.feedbackText = "\(feedback) (\(Int(rightAngle))°) - Rep: \(self.repetitionCount)/\(self.maxRepetitions)"
                self.overlayColor = color
            }
        }
    }
}
