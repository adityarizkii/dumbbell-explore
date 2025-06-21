//
//  CountDownView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 20/06/25.
//

import SwiftUI


struct CountDownView: View {
    @State private var count: Int = 3
    @State private var progress: Double = 0.0
    @State private var showReady = true
    
    let totalCount = 3
    @State private var degree : Double = -270
    
    var body: some View {
        VStack{
            ZStack {
                // Background ring
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(showReady ? 0.0 : 0.3)
                    .foregroundColor(Color("Button1"))
                
                // Smooth animated progress ring
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .rotationEffect(.degrees(degree))
                    .animation(.linear(duration: Double(totalCount)), value: progress)
                
                // Countdown label
                Text(showReady ? "Ready" :"\((count))"  )
                    .font(.system(size: 40 , weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 229, height: 229)
            .onAppear {
                // Trigger animation when the view appears
                withAnimation(.linear(duration: Double(totalCount))) {
                    progress = 1.0 // Start progress from 0 to 1
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalCount)) {
                    startCountdown()
                }

                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    func startCountdown() {
        // Start progress animation from full circle (1.0) to empty (0.0)
        withAnimation(.linear(duration: Double(totalCount))) {
            progress = 0.0 // Progress becomes 0.0 after animation
        }
        degree = -90
        showReady = false
        
        // Update countdown numbers every second
        for i in 0..<totalCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                count = totalCount - i
            }
        }
        
        // After all ticks, show "Ready!"
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalCount)) {
//            showReady = true
//            degree = 0
//        }
    }
}



#Preview {
    CountDownView()
}
