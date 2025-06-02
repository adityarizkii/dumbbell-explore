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
    
    private let sequenceHandler = VNSequenceRequestHandler()
    private var lastRightWristPoint: CGPoint?
    private var lastLeftWristPoint: CGPoint?
    private let positionTolerance: CGFloat = 0.2
    
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
    
    private func evaluatePose(points: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]) {
        DispatchQueue.main.async {
            self.currentPoints = points
            
            guard let rightShoulder = points[.rightShoulder],
                  let rightElbow = points[.rightElbow],
                  let rightWrist = points[.rightWrist],
                  let leftShoulder = points[.leftShoulder],
                  let leftElbow = points[.leftElbow],
                  let leftWrist = points[.leftWrist],
                  rightShoulder.confidence > 0.5,
                  rightElbow.confidence > 0.5,
                  rightWrist.confidence > 0.5,
                  leftShoulder.confidence > 0.5,
                  leftElbow.confidence > 0.5,
                  leftWrist.confidence > 0.5 else {
                self.feedbackText = "Pose tidak jelas"
                self.overlayColor = .gray
                return
            }
            
            let convertPoint: (VNRecognizedPoint) -> CGPoint = { point in
                CGPoint(x: CGFloat(point.location.x), y: CGFloat(1 - point.location.y))
            }
            
            // Right side points
            let rightShoulderPt = convertPoint(rightShoulder)
            let rightElbowPt = convertPoint(rightElbow)
            let rightWristPt = convertPoint(rightWrist)
            
            // Left side points
            let leftShoulderPt = convertPoint(leftShoulder)
            let leftElbowPt = convertPoint(leftElbow)
            let leftWristPt = convertPoint(leftWrist)
            
            // Check if wrist positions have changed significantly
            let rightWristChanged = self.lastRightWristPoint == nil || 
                abs(rightWristPt.x - self.lastRightWristPoint!.x) > self.positionTolerance ||
                abs(rightWristPt.y - self.lastRightWristPoint!.y) > self.positionTolerance
                
            let leftWristChanged = self.lastLeftWristPoint == nil ||
                abs(leftWristPt.x - self.lastLeftWristPoint!.x) > self.positionTolerance ||
                abs(leftWristPt.y - self.lastLeftWristPoint!.y) > self.positionTolerance
            
            if rightWristChanged || leftWristChanged {
                print("\n=== Converted Points ===")
                print("Right Side:")
//                print("Shoulder: x: \(rightShoulderPt.x), y: \(rightShoulderPt.y)")
//                print("Elbow: x: \(rightElbowPt.x), y: \(rightElbowPt.y)")
                print("Wrist: x: \(rightWristPt.x), y: \(rightWristPt.y)")
                print("\nLeft Side:")
//                print("Shoulder: x: \(leftShoulderPt.x), y: \(leftShoulderPt.y)")
//                print("Elbow: x: \(leftElbowPt.x), y: \(leftElbowPt.y)")
                print("Wrist: x: \(leftWristPt.x), y: \(leftWristPt.y)")
                print("=====================\n")
                
                // Update last positions
                self.lastRightWristPoint = rightWristPt
                self.lastLeftWristPoint = leftWristPt
            }
            
            // Comment out angle calculations for now
            /*
            let rightAngle = self.angleBetweenPoints(pointA: rightWristPt, pointB: rightElbowPt, pointC: rightShoulderPt)
            let leftAngle = self.angleBetweenPoints(pointA: leftWristPt, pointB: leftElbowPt, pointC: leftShoulderPt)
            
            if rightAngle > 150 || leftAngle > 150 {
                self.feedbackText = "Turunkan dumbbell"
                self.overlayColor = .red
            } else if rightAngle < 40 || leftAngle < 40 {
                self.feedbackText = "Angkat dumbbell lebih tinggi"
                self.overlayColor = .yellow
            } else {
                self.feedbackText = "Gerakan bagus!"
                self.overlayColor = .green
            }
            */
            
            // Set default feedback for now
            self.feedbackText = "Pose terdeteksi"
//            self.feedbackText = "Wrist: x: \(rightWristPt.x), y: \(rightWristPt.y)"
            self.overlayColor = .green
        }
    }
}
