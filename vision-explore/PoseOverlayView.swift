//
//  PoseOverlayView.swift
//  vision-explore
//
//  Created by Aditya Rizki on 28/05/25.
//

import SwiftUI
import Vision

struct PoseOverlayView: View {
    let points: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]
    let evaluationColor: Color
    
    // Only include right arm joint pairs
    let jointPairs: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
        (.rightShoulder, .rightElbow),
        (.rightElbow, .rightWrist)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw lines between joints
                ForEach(Array(jointPairs.enumerated()), id: \.offset) { _, pair in
                    let jointA = pair.0
                    let jointB = pair.1
                    
                    if let pointA = points[jointA], let pointB = points[jointB],
                       pointA.confidence > 0.1, pointB.confidence > 0.1 {
                        
                        Path { path in
                            let rotatedX1 = 1 - pointA.location.y
                            let rotatedY1 = pointA.location.x
                            let rotatedX2 = 1 - pointB.location.y
                            let rotatedY2 = pointB.location.x
                            
                            path.move(to: CGPoint(x: rotatedX1 * geometry.size.width, y: rotatedY1 * geometry.size.height))
                            path.addLine(to: CGPoint(x: rotatedX2 * geometry.size.width, y: rotatedY2 * geometry.size.height))
                        }
                        .stroke(evaluationColor, lineWidth: 2)
                    }
                }
                
                // Draw joint points (only right arm)
                ForEach([VNHumanBodyPoseObservation.JointName.rightShoulder,
                         .rightElbow,
                         .rightWrist], id: \.self) { key in
                             if let point = points[key], point.confidence > 0.1 {
                                 let rotatedX = 1 - point.location.y
                                 let rotatedY = point.location.x
                                 
                                 Circle()
                                     .fill(Color.blue.opacity(0.7))
                                     .frame(width: 10, height: 10)
                                     .position(
                                        x: rotatedX * geometry.size.width,
                                        y: rotatedY * geometry.size.height
                                     )
                             }
                         }
                // 🔢 Display the angle at the elbow
                if let shoulder = points[.rightShoulder],
                   let elbow = points[.rightElbow],
                   let wrist = points[.rightWrist],
                   shoulder.confidence > 0.1,
                   elbow.confidence > 0.1,
                   wrist.confidence > 0.1 {
                    
                    // Convert normalized Vision points to screen coordinates
                    let shoulderPt = CGPoint(x: (1 - shoulder.location.y) * geometry.size.width,
                                             y: shoulder.location.x * geometry.size.height)
                    let elbowPt = CGPoint(x: (1 - elbow.location.y) * geometry.size.width,
                                          y: elbow.location.x * geometry.size.height)
                    let wristPt = CGPoint(x: (1 - wrist.location.y) * geometry.size.width,
                                          y: wrist.location.x * geometry.size.height)
                    
                    // Compute vectors
                    let upperArm = CGVector(dx: shoulderPt.x - elbowPt.x, dy: shoulderPt.y - elbowPt.y)
                    let forearm = CGVector(dx: wristPt.x - elbowPt.x, dy: wristPt.y - elbowPt.y)
                    
                    // Compute angle using dot product
                    let dotProduct = upperArm.dx * forearm.dx + upperArm.dy * forearm.dy
                    let magnitudeProduct = hypot(upperArm.dx, upperArm.dy) * hypot(forearm.dx, forearm.dy)
                    
                    let angleRadians = acos(max(min(dotProduct / magnitudeProduct, 1), -1))
                    let angleDegrees = angleRadians * 180 / .pi
                    
                    // Display the angle text
                    Text("\(Int(angleDegrees))°")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .position(x: elbowPt.x, y: elbowPt.y - 20)
                }
            }
        }
    }
}
