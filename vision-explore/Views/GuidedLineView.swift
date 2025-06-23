//
//  GuidedLineView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.


import SwiftUI
import SwiftUI

struct GuidedLineView: View {
    @State private var count: Int = 3
    @State private var progress: Double = 0.0
    @State private var showReady = false
    @State private var rotation: Angle = .degrees(0)
    
    let totalCount = 3
    
    @State private var currentTarget: CGPoint = .zero
    @State private var currentIndex: Int = 0
    
    @State private var points: [CGPoint] = []
    
    @State private var arcProgress: CGFloat = 0.0
    @State private var goingForward = true
    
    @State private var repeatCount = 0
    
    var wristPoint: CGPoint?
    var elbowPoint: CGPoint?
    
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            // Safe unwrap of optional wristPoint and elbowPoint
            
            
            if let pointAref = elbowPoint , let pointBref = wristPoint {
                // Continue the regular logic when both points are available
                let pointA = CGPoint(
                    x: pointAref.x * width,   // Scale x-coordinate
                    y: pointAref.y * height   // Scale y-coordinate
                )
                
                let pointB = CGPoint(
                    x: pointBref.x * width,   // Scale x-coordinate
                    y: pointBref.y * height   // Scale y-coordinate
                )
                
                // Start point of arc
                let dx = pointB.x - pointA.x
                let dy = pointB.y - pointA.y
                let radius = sqrt(dx * dx + dy * dy)
                
                let startAngle = Angle(radians: atan2(dy, dx))
                let endAngle = Angle(degrees: startAngle.degrees + 135)
                
                let endRadians = endAngle.radians
                let endPoint = CGPoint(
                    x: pointA.x + radius * cos(endRadians),
                    y: pointA.y + radius * sin(endRadians)
                )
                
                let startRad = startAngle.radians
                let endRad = endAngle.radians
                let delta = endRad - startRad
                
                // Centered short arc = from 25% to 75%
                let midStart = Angle(radians: startRad + 0.25 * delta)
                let midEnd   = Angle(radians: startRad + 0.75 * delta)
                
                let midEndRadians = CGFloat(midEnd.radians)

                let angleRad = CGFloat(midEnd.radians)
                let trianglePoint = CGPoint(
                    x: pointA.x + radius * cos(angleRad),
                    y: pointA.y + radius * sin(angleRad)
                )
                
                let arcStep: CGFloat = 0.001 // small delta forward
                let futureAngle = angleRad + arcStep
                let futurePoint = CGPoint(
                    x: pointA.x + radius * cos(futureAngle),
                    y: pointA.y + radius * sin(futureAngle)
                )
                
                let dx2 = futurePoint.x - trianglePoint.x
                let dy2 = futurePoint.y - trianglePoint.y
                let triangleAngle = Angle(radians: atan2(dy2, dx2)) + .degrees(90)
                
                let angle = startAngle.radians + Double(arcProgress)
                
                let movingPoint = CGPoint(
                    x: pointA.x + radius * cos(angle),
                    y: pointA.y + radius * sin(angle)
                )
                
                
                var animatedMovingPoint: CGPoint {
                    let angle = CGFloat(startAngle.radians + arcProgress
                                        * (endAngle.radians - startAngle.radians)
                    )
                    return CGPoint(
                        x: pointA.x + radius * cos(angle),
                        y: pointA.y + radius * sin(angle)
                    )
                }
                
                ZStack {
                    // Visual helpers
                    Circle()
                        .fill(Color("Button1"))
                        .frame(width: 30, height: 30)
                        .position(pointA)
                    
                    Circle()
                        .fill(Color("Button1"))
                        .frame(width: 20, height: 20)
                        .position(pointB)
                    
                    ZStack {
                        // Arc path
                        Path { path in
                            path.addArc(
                                center: pointA,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: false
                            )
                        }
                        .stroke(
                            Color.white.opacity(0.4),
                            style: StrokeStyle(
                                lineWidth: 30,
                                lineCap: .round
                            )
                        )
                        Path { path in
                            path.addArc(
                                center: pointA,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: false
                            )
                        }
                        .trim(from: 0.0, to: arcProgress)
                        .stroke(
                            Color("Button1"),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                    }
                    
                    ZStack{
                        
                        Circle()
                            .fill(Color("Button1"))
                            .frame(width: 50, height: 50)
                            .position(endPoint)
                        
                        ZStack {
                            Circle()
                                .fill(Color("Button1"))
                                .frame(width: 50, height: 50)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 8)
                                .frame(width: 60, height: 60)
                            // Background ring
                            Circle()
                                .stroke(lineWidth: 8)
                                .opacity(0.3)
                                .foregroundColor(.white)
                            
                            // Smooth animated progress ring
                            Circle()
                                .stroke(
                                    Color.white.opacity(0.3),
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: Double(totalCount)), value: progress)
                                
                        }
                        .frame(width: 100, height: 100)
                        .position(animatedMovingPoint) //
                        .onAppear {
                            points = [pointB, endPoint]
                            currentIndex = 0
                            currentTarget = pointB
                            startCountdown()
                        }

                    }
                }
            } else {
                // Display message if wrist or elbow points are not available
                Text("Wrist or Elbow point not detected")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
    
    func startCountdown() {
        count = totalCount
        let steps = 60
        let stepDuration = Double(totalCount) / Double(steps)
        var currentStep = 0

        // Stop any previous timers if needed (not shown here)
        Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            let t = Double(currentStep) / Double(steps)
            arcProgress = goingForward ? CGFloat(t) : CGFloat(1.0 - t)

            currentStep += 1
            if currentStep > steps {
                timer.invalidate()
                goingForward.toggle()
                showReady = true
                repeatCount += 1
                if repeatCount < 16 {
                    startCountdown()
                }
            }
        }

        for i in 0..<totalCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                count = totalCount - i
            }
        }
    }
}

#Preview {
    GuidedLineView()
        .environmentObject(RouteManager())

}
