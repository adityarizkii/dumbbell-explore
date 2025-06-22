//
//  GuidedLineView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.


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
    
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            // Center of arc
            let pointA = CGPoint(x: width * 0.70, y: height * 0.40)
            
            // Start point of arc
            let pointB = CGPoint(x: width * 0.70, y: height * 0.65)
            
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
//            * (endAngle.radians - startAngle.radians)
            
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
                
//                Path { path in
//                    path.move(to: pointA)
//                    path.addLine(to: pointB)
//                }
//                .stroke(
//                    Color("Button1"), // or Color("Button1")
//                    style: StrokeStyle(
//                        lineWidth: 6,
//                        dash: [10, 10] // 5pt line, 5pt gap
//                    )
//                )
                
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
//                        AngularGradient(
//                            gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
//                            center: .center
//                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    
                    
                    
                    // Short inner arc (e.g. direction / progress)
//                    Path { path in
//                        path.addArc(
//                            center: pointA,
//                            radius: radius,
//                            startAngle: midStart,
//                            endAngle: midEnd,
//                            clockwise: false
//                        )
//                    }
//                    .stroke(
//                        Color("Button1"),
//                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
//                    )
                    
//                    ArrowHead()
//                        .fill(Color("Button1"))
//                        .frame(width: 20, height: 20)
//                        .rotationEffect(triangleAngle,anchor: .center)
//                        .position(trianglePoint)
                    
                    
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
    //                        .position(endPoint)
                        
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
//                            .trim(from: 0.0, to: arcProgress)
                            .stroke(
                                Color.white.opacity(0.3),
//                                AngularGradient(
//                                    gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
//                                    center: .center
//                                ),
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
        }
        .background(Color.black)
    }
    
//    func startCountdown() {
//        count = totalCount
//        
//
//        // Animate arc progress forward or backward
//        withAnimation(.linear(duration: Double(totalCount))) {
//            arcProgress = goingForward ? 1.0 : 0.0
//        }
//
//        // Countdown number display
//        for i in 0..<totalCount {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                count = totalCount - i
//            }
//        }
//
//        // After countdown
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalCount)) {
//            showReady = true
//            goingForward.toggle() // reverse direction
//            startCountdown()      // repeat
//        }
//    }
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



    
//    func startCountdown() {
//        count = totalCount
//        
//        // Animate ring if needed (optional)
//        withAnimation(.linear(duration: Double(totalCount))) {
//            progress = 1.0
//        }
//        print(totalCount)
//        
//        // Schedule countdown: 3, 2, 1
//        for i in 0..<totalCount {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                count = totalCount - i
//            }
//        }
////        print(currentTarget)
//        print("current index: \(currentIndex)")
//        print("total count: \(totalCount)")
//        print("count: \(count)")
//        
//        // When countdown is finished
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalCount)) {
//            // Move to next target
//            
//            currentIndex = (currentIndex + 1) % 2
//            print(currentTarget)
//            currentTarget = points[currentIndex]
//            print(currentTarget)
//            // Restart countdown
//            progress = 0.0
//            startCountdown()
//        }
//    }
    
    
    
    
    
}

struct ArrowHead: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let tip = CGPoint(x: rect.midX, y: rect.minY)
            let left = CGPoint(x: rect.minX, y: rect.maxY)
            let right = CGPoint(x: rect.maxX, y: rect.maxY)
            
            path.move(to: tip)
            path.addLine(to: left)
            path.addLine(to: right)
            path.closeSubpath()
        }
    }
}

#Preview {
    GuidedLineView()
}
