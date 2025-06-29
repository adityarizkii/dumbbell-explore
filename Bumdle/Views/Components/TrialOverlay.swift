//
//  TrialOverlay.swift
//  Bumdle
//
//  Created by M Ikhsan Azis Pane on 29/06/25.
//

import SwiftUI

struct TrialOverlay: View {
    
    @State private var isVisible = false
    @State private var progress = 0.0
    
    @State private var count: Int = 1
    @State private var showReady = false
    let totalCount = 1
    
    var body: some View {
        GeometryReader { geo in
            let frameHeight = geo.size.height * 0.75
            //            let frameHeight: CGFloat = 680
            let cornerRadius: CGFloat = 15
            let size = geo.size
            let circleSize: CGFloat = 200
            
            let height = geo.size.height
            let width = geo.size.width
            ZStack {
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
                    .offset(y: 20)
                    .padding(.top, 30)
                    .frame(maxWidth : 0.8 * width/2, maxHeight: 0.5 *  height, alignment: .trailing)
                    .animation(.linear(duration: Double(totalCount)), value: progress)
                
            }
            .padding(.trailing, 40)
            .frame(maxWidth: .infinity, maxHeight: geo.size.height, alignment: .trailing)
            .compositingGroup()
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .onAppear {
                startCountdown()
            }
            
        }
        .frame(maxWidth : .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        //        .background(Color.red.opacity(0.3))
        
    }
    
    func startCountdown() {
        // Gradually update progress over time
        var timerCount = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
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
    TrialOverlay()
}
