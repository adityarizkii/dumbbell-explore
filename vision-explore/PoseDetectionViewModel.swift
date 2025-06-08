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
    
    private let sequenceHandler = VNSequenceRequestHandler()
    
    // Constants for dumbbell curl exercise
    private let curlUpAngle: CGFloat = 135.0    // Angle threshold for curl up position
    private let curlDownAngle: CGFloat = 65.0   // Angle threshold for curl down position
    private let maxRepetitions: Int = 5
    
    // State for tracking exercise phase
    private var isInUpPosition: Bool = false
    private var isInDownPosition: Bool = false
    
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
        // Update exercise phase
        if angle < curlDownAngle {
            isInDownPosition = true
            isInUpPosition = false
            return ("Turunkan dumbbell", .red)
        } else if angle > curlUpAngle {
            isInUpPosition = true
            return ("Angkat dumbbell lebih tinggi", .yellow)
        } else {
            // Check for completed repetition
            if isInDownPosition && isInUpPosition {
                repetitionCount += 1
                isInDownPosition = false
                isInUpPosition = false
                
                if repetitionCount >= maxRepetitions {
                    DispatchQueue.main.async {
                        self.showCompletionAlert = true
                    }
                }
            }
            return ("Gerakan bagus!", .green)
        }
    }
    
    func resetExercise() {
        repetitionCount = 0
        isInUpPosition = false
        isInDownPosition = false
        showCompletionAlert = false
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
            
            print("Confident: \(rightShoulder?.confidence ?? 0), \(rightElbow?.confidence ?? 0), \(rightWrist?.confidence ?? 0)")
            
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
                print("Right Angle: \(rightAngle)")
                
                let (feedback, color) = self.evaluateDumbbellCurl(angle: rightAngle)
                self.feedbackText = "\(feedback) (\(Int(rightAngle))°) - Rep: \(self.repetitionCount)/\(self.maxRepetitions)"
                self.overlayColor = color
            }
        }
    }
}
