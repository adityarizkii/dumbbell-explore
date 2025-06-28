//
//  GuidedLineView.swift
//  Bumdle
//
//  Created by M Ikhsan Azis Pane on 21/06/25.
import SwiftUI
import Vision

struct TrialGuideLine: View {
    @StateObject var trialVM: TrialViewModel
    @EnvironmentObject var exerciseManager : ExerciseManager

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

    var wristPoint: CGPoint?
    var elbowPoint: CGPoint?

    let totalCount = 3

    var body: some View {
        GeometryReader { geometry in
            if let pointAref = elbowPoint, let pointBref = wristPoint {
                let width = geometry.size.width
                let height = geometry.size.height

                // Dynamic points
                let pointA = CGPoint(x: pointAref.x * width, y: pointAref.y * height)
                let pointB = CGPoint(x: pointBref.x * width, y: pointBref.y * height)

                let dx = pointB.x - pointA.x
                let dy = pointB.y - pointA.y
                let radius = sqrt(dx * dx + dy * dy)

                let startAngle = Angle(radians: atan2(dy, dx))
                let endAngle = Angle(degrees: startAngle.degrees + abs(exerciseManager.exercise.config.upAngle - exerciseManager.exercise.config.downAngle))

                let animatedAngle = CGFloat(startAngle.radians + arcProgress * (endAngle.radians - startAngle.radians))
                let animatedPoint = CGPoint(
                    x: pointA.x + radius * cos(animatedAngle),
                    y: pointA.y + radius * sin(animatedAngle)
                )

                ZStack {
                    
                    // Elbow point visual
                    Circle()
                        .fill(Color("Button1"))
                        .frame(width: 30, height: 30)
                        .position(pointA)

                    // Wrist point visual
                    Circle()
                        .fill(Color("Button1"))
                        .frame(width: 20, height: 20)
                        .position(pointB)

                    // Arc paths
                    Path { path in
                        path.addArc(
                            center: pointA,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                    }
                    .stroke(Color.white.opacity(0.4), style: StrokeStyle(lineWidth: 30, lineCap: .round))

                    // Progress arc
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
                    .stroke(Color("Button1"), style: StrokeStyle(lineWidth: 15, lineCap: .round))

                    // Target + moving circle
                    ZStack {
                        // Target
                        Circle()
                            .fill(Color("Button1"))
                            .frame(width: 50, height: 50)
                            .position(
                                CGPoint(
                                    x: pointA.x + radius * cos(CGFloat(endAngle.radians)),
                                    y: pointA.y + radius * sin(CGFloat(endAngle.radians))
                                )
                            )

                        // Moving animated circle
                        ZStack {
                            Circle()
                                .fill(Color("Button1"))
                                .frame(width: 50, height: 50)

                            Circle()
                                .stroke(Color.white, lineWidth: 8)
                                .frame(width: 60, height: 60)

                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                                .frame(width: 60, height: 60)

                            Circle()
                                .stroke(
                                    Color.white.opacity(0.3),
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(width: 100, height: 100)
                        .position(animatedPoint)
                        .onAppear {
                            startCountdown()
                            trialVM.playSound()
                        }
                    }
//                    let rectSize = CGSize(width: 0.5, height: 0.15) // bisa di-tweak sesuai kebutuhan
//
//                    Rectangle()
//                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
//                        .frame(width: rectSize.width * width, height: rectSize.height * height)
//                        .position(CGPoint(x: wristPoint!.x * width, y: wristPoint!.y * height))

                }
                .onChange(of: wj) { newWrist in
                    // optionally: log atau update sesuatu jika perlu
                    print("Wrist updated: \(String(describing: newWrist))")
                }

            } else {
                Text("Wrist or Elbow not detected")
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }

    // MARK: - Countdown & Progress
    func startCountdown() {
        count = totalCount
        let steps = 60
        let stepDuration = Double(totalCount) / Double(steps)
        var currentStep = 0

        Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            if step < maxStep {
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
                            isPaused = true
                            startCountdown()
                        }
                    }
                } else {
                    guard let wrist = wj else { return }
                    let radius: CGFloat = 0.2
                    let rectSize = CGSize(width: 0.5, height: 0.15) // bisa di-tweak sesuai kebutuhan

                    if (step % 2 == 0 && isPoint(wrist, insideRectWithCenter: wristPoint ?? .zero, size: rectSize)) ||
                       (step % 2 == 1 && isPoint(wrist, insideRectWithCenter: elbowPoint ?? .zero, size: rectSize)) {

                        isPaused = false
                        step += 1
                        trialVM.playSound()
                    }
                }
            } else {
                timer.invalidate()
            }
        }
    }

    func isPoint(_ point: CGPoint, insideRectWithCenter center: CGPoint, size: CGSize) -> Bool {
        let dx = abs(point.x - center.x)
        let dy = abs(point.y - center.y)
        return dx <= size.width / 2 && dy <= size.height / 2
    }
}
