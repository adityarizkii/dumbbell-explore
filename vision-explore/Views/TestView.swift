//
//  TestView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.
//
//
//import SwiftUI
//
//struct TestView: View {
//    @State private var arcProgress: CGFloat = 0.0
//    let totalCount = 3.0
//    
//    var body: some View {
//        ZStack {
//            // Inner filled circle
//            Circle()
//                .fill(Color("Button1"))
//                .frame(width: 50, height: 50)
//            
//            // Outer white stroke
//            Circle()
//                .stroke(Color.white, lineWidth: 8)
//                .frame(width: 60, height: 60)
//            
//            // Background ring
//            Circle()
//                .stroke(lineWidth: 8)
//                .opacity(0.3)
//                .foregroundColor(.white)
//                .frame(width: 100, height: 100) // radius 150
//            
//            // Progress ring
//
//            
//            Circle()
//                .trim(from: 0.0, to: arcProgress)
//                .stroke(
//                    AngularGradient(
//                        gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
//                        center: .center
//                    ),
//                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
//                )
//                .rotationEffect(.degrees(-90)) // Start from top
//                .frame(width: 100, height: 100)
//                .animation(.linear(duration: totalCount), value: arcProgress)
//            
//            Circle()
//                .trim(from: 0.0, to: arcProgress)
//                .stroke(Color.white, lineWidth: 8)
//                .rotationEffect(.degrees(-90)) // Start from top
//                .frame(width: 300, height: 300)
//            
//            
//        }
//        .onAppear {
//            arcProgress = 1.0 // Animate from 0 → 1
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//    }
//}
//
//#Preview {
//    TestView()
//}
import SwiftUI

struct TestView: View {
    @State private var progress: Double = 0.0
    let radius: CGFloat = 150
    let duration: Double = 3.0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let date = timeline.date.timeIntervalSinceReferenceDate
            let phase = (date.truncatingRemainder(dividingBy: duration)) / duration
            
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 8)
                    .frame(width: radius * 2, height: radius * 2)

                // Progress ring (optional)
                Circle()
                    .trim(from: 0.0, to: phase)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: radius * 2, height: radius * 2)

                // Moving dot
                Circle()
                    .fill(Color("Button1"))
                    .frame(width: 30, height: 30)
                    .position(movingPoint(phase: phase, center: CGPoint(x: radius, y: radius)))
            }
            .frame(width: radius * 2, height: radius * 2)
        }
        .background(Color.black.ignoresSafeArea())
    }

    func movingPoint(phase: Double, center: CGPoint) -> CGPoint {
        let angle = 2 * .pi * phase - .pi / 2 // start from top
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    TestView()
}

