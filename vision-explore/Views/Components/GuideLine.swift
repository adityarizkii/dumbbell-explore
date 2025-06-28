//
//  GuidedLineView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.


import SwiftUI
import Vision

struct GuideLine: View {
    @StateObject var trialVM: TrialViewModel
    @EnvironmentObject var routeManager : RouteManager
    @EnvironmentObject var exerciseManager : ExerciseManager
    let speechManager: SpeechManager = SpeechManager()
    
    @State private var count: Int = 3
    @State private var progress: Double = 0.0
    @State private var showReady = false
    @State private var arcProgress: CGFloat = 0.0
    @State private var goingForward = true
    @State private var repeatCount = 0
    
    @Binding var isPaused: Bool
    @Binding var pointJoint: [VNHumanBodyPoseObservation.JointName: VNRecognizedPoint]?
    @Binding var wj: CGPoint? // wrist joint
    @Binding var step: Int
    @Binding var maxStep: Int
    
    @State var wristPoint: CGPoint?
    @State var elbowPoint: CGPoint?
    @State var shoulderPoint: CGPoint?
    
    var totalCount : Int!
    @Binding var repetition : Int!
    @State var maxRepetition : Int!
    
    @State var pA: CGPoint = CGPoint(x : 0, y : 0)
    @State var pB: CGPoint = CGPoint(x : 0, y : 0)
    var side : position
    
    @State private var currentTarget: CGPoint = .zero
    @State private var currentIndex: Int = 0
    
    @State private var points: [CGPoint] = []
        
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            if let pointAref = elbowPoint , let pointBref = wristPoint, let pointCref = shoulderPoint {
                let pointA = CGPoint(
                    x: pointAref.x * width,
                    y: pointAref.y * height
                )
                
                let pointB = CGPoint(
                    x: pointBref.x * width,
                    y: pointBref.y * height
                )
                
                let pointC = CGPoint(
                    x: pointCref.x * width,
                    y: pointCref.y * height
                )
                
                let dx = pointB.x - pointA.x
                let dy = pointB.y - pointA.y
                let radius = sqrt(dx * dx + dy * dy)
                
                var sideangle = exerciseManager.exercise.config.upAngle * ( side == .left ? -1 : 1)
                
                let startAngle = Angle(radians: atan2(dy, dx))
                let endAngle = Angle(degrees: startAngle.degrees + sideangle)
                
                let endRadians = endAngle.radians
                let endPoint = CGPoint(
                    x: pointA.x + radius * cos(endRadians),
                    y: pointA.y + radius * sin(endRadians)
                )
                
                let endPoints = CGPoint(
                    x: 1 - ((pointA.x + radius * cos(endRadians))/width),
                    y: (pointA.y + radius * sin(endRadians))/height
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
                        .position(pointC)
                    
                    
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
                                clockwise: side == .left
                                
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
                                clockwise: side == .left
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
                            .onAppear(){
                                
                                let pb = CGPoint(
                                    x : 1 - pointBref.x,
                                    y : pointBref.y
                                )
                                self.pA = endPoints
                                self.pB = pb
                            }
                        
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
            }
        }
            
            // MARK: - Countdown & Progress
            
        }
    

        func startCountdown() {
            count = totalCount
            let steps = 60
            let stepDuration = Double(totalCount) / Double(steps)
            var currentStep = 0
            
            Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
                
                if !isPaused {
                    let t = Double(currentStep) / Double(steps)
                    arcProgress = goingForward ? CGFloat(t) : CGFloat(1.0 - t)
                    
                    currentStep += 1
                    if currentStep > steps {
                        timer.invalidate()
                        goingForward.toggle()
                        showReady = true
                        repeatCount += 1
                        
                        if repeatCount < 16 {
                            timer.invalidate()
                           
                            isPaused = true
                            startCountdown()
                        }
                    }
                } else {
                    guard let wrist = wj else { return }
                    let radius: CGFloat = 0.1
                    let rectSize = CGSize(width: 0.5, height: 0.2) // bisa di-tweak sesuai kebutuhan
                    
//                    let hitA = (step % 2 == 0 && isPoint(wrist, insideRectWithCenter: wristPoint ?? .zero, size: rectSize))
//                    let hitB = (step % 2 == 1 && isPoint(wrist, insideRectWithCenter: elbowPoint ?? .zero, size: rectSize))
                    //
                    let hitA = (step % 2 == 0 && self.isPoint(wrist, insideCircleWithCenter: self.pA ?? .zero, radius: radius))
                    let hitB = (step % 2 == 1 && self.isPoint(wrist, insideCircleWithCenter: self.pB ?? .zero, radius: radius))
                    
                    
                    if  hitA || hitB
                    {
                        speechManager.speak(step % 2 == 0 ? "Move your wrist down"  : "Move your wrist up")

                        if hitA {
                            repetition += 1
                            
                        }
                        isPaused = false
                        step += 1
                        if repetition >= maxRepetition{
                            if side == .left {
                                // Setelah lengan kanan selesai (user menghadap kiri), lanjut ke lengan kiri
                                routeManager.push("leftworkout")
                            } else {
                                // Setelah lengan kiri selesai (user menghadap kanan), lanjut ke finished
                                routeManager.clear()
                                routeManager.push("finished")
                            }
                            timer.invalidate()
                        }
                    }
                    
                    
                }
                
            }
        }
    
        func isPoint(_ point: CGPoint, insideCircleWithCenter center: CGPoint, radius: CGFloat) -> Bool {
            let dx = point.y - center.x
            let dy = point.x - center.y
            print("Hell nah :  \(dx * dx + dy * dy <= radius * radius)")
            
            return dx * dx + dy * dy <= radius * radius
        }
    
//    func isPoint(_ point: CGPoint, insideRectWithCenter center: CGPoint, size: CGSize) -> Bool {
//        let dx = abs(point.x - center.x)
//        let dy = abs(point.y - center.y)
//        return dx <= size.width / 2 && dy <= size.height / 2
//    }
}
//
//#Preview {
//    GuideLine()
//        .environmentObject(RouteManager())
//
//}
