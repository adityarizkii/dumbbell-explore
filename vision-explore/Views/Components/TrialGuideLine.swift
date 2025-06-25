//
//  GuidedLineView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.


import SwiftUI
import SwiftUI
import Vision

struct TrialGuideLine: View {
    @StateObject var trialVM : TrialViewModel

    @State private var count: Int = 3
    @State private var progress: Double = 0.0
    @State private var showReady = false
    @State private var rotation: Angle = .degrees(0)
    @Binding var isPaused : Bool
    @Binding var pointJoint: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]?
    @Binding var wj : CGPoint?
    
    let totalCount = 3
    
    @State private var currentTarget: CGPoint = .zero
    @State private var currentIndex: Int = 0
    
    @State private var points: [CGPoint] = []
    
    @State private var arcProgress: CGFloat = 0.0
    @State private var goingForward = true
    
    @State private var repeatCount = 0
    
    @State var pA: CGPoint = CGPoint(x : 0, y : 0)
    @State var pB: CGPoint = CGPoint(x : 0, y : 0)
    
    
    var wristPoint: CGPoint?
    var elbowPoint: CGPoint?
    @Binding var step : Int
    @Binding var maxStep : Int

    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            if let pointAref = elbowPoint , let pointBref = wristPoint {
                let pointA = CGPoint(
                    x: pointAref.x * width,
                    y: pointAref.y * height
                )
                
                let PA = CGPoint(x: pointAref.x, y: pointAref.y)
                let PB = CGPoint(x: pointBref.x, y: pointBref.y)
                
                let pointB = CGPoint(
                    x: pointBref.x * width,
                    y: pointBref.y * height
                )
                
                let dx = pointB.x - pointA.x
                let dy = pointB.y - pointA.y
                let radius = sqrt(dx * dx + dy * dy)
                
                let startAngle = Angle(radians: atan2(dy, dx))
                let endAngle = Angle(degrees: startAngle.degrees + 70)
                
                let endRadians = endAngle.radians
                let endPoint = CGPoint(
                    x: pointA.x + radius * cos(endRadians),
                    y: pointA.y + radius * sin(endRadians)
                )
                
                let startRad = startAngle.radians
                let endRad = endAngle.radians
                let delta = endRad - startRad
                
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
                        .onAppear {
                            self.pA = PA
                        }
                    
                    Circle()
                        .fill(Color("Button1"))
                        .frame(width: 20, height: 20)
                        .position(pointB)
                        .onAppear {
                            self.pB = PB
                        }
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
                            trialVM.playSound()
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
            
            if step < maxStep{
                print("Posisi : \( String(describing: wj)) andddddd \(  (step % 2) == 1 ? self.pB : self.pA)")
                if !isPaused{
                    let t = Double(currentStep) / Double(steps)
                    arcProgress = goingForward ? CGFloat(t) : CGFloat(1.0 - t)

                    currentStep += 1
                    if currentStep > steps {
                        timer.invalidate()
                        goingForward.toggle()
                        showReady = true
                        repeatCount += 1
                        if repeatCount < 16 {
                            
                            isPaused = true
                            startCountdown()
                        }
                    }
                }else{
                    if (step % 2) == 0 && isPoint(wj ?? CGPoint(x : 0, y : 0), insideCircleWithCenter: self.pB, radius: CGFloat(0.15)){
                        isPaused = false
                        step += 1
                        trialVM.playSound()
                        
                    }
                    
                    if (step % 2) == 1 && isPoint(wj ?? CGPoint(x : 0, y : 0), insideCircleWithCenter: self.pA, radius: CGFloat(0.15)){
                        isPaused = false
                        step += 1
                        trialVM.playSound()
                        
                    }
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
    GuideLine()
        .environmentObject(RouteManager())

}
