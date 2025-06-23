//
//  FrameOverlay.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.
//
import SwiftUI

struct FrameOverlayAnimation: View {
    @State private var count: Int = 3
    @State private var progress: Double = 0.0
    @State private var showReady = false
    let totalCount = 3
    
    var body: some View {
        GeometryReader { geo in
            let frameHeight = geo.size.height * 0.8
            let cornerRadius: CGFloat = 15

            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
                    .blendMode(.destinationOut)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                            startPoint: .trailing,
                            endPoint: .leading
                        ),
                        lineWidth: 4
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
                    .animation(.linear(duration: Double(totalCount)), value: progress)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .compositingGroup()
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .onAppear {
                startCountdown()
            }
        }
        .ignoresSafeArea()
    }
    
    func startCountdown() {
        // Gradually update progress over time
        var timerCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timerCount < totalCount {
                // Increment progress smoothly
                progress = Double(timerCount + 1) / Double(totalCount)
                count = totalCount - timerCount
                timerCount += 1
            } else {
                // Stop the timer and show "Ready!" when countdown ends
                showReady = true
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
}

#Preview {
    FrameOverlayAnimation()
}
