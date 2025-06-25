//
//  FrameOverlay.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.
//
import SwiftUI

struct FrameOverlayAnimation: View {
    @State private var count: Int = 1
    @State private var progress: Double = 0.0
    @State private var showReady = false
    let totalCount = 1
    
    var body: some View {
        GeometryReader { geometry in
            let frameHeight = geometry.size.height * 0.8
            let height = geometry.size.height
            let width = geometry.size.width/2
            let cornerRadius: CGFloat = 10

            ZStack {
                
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 50)
//                    .offset(y: 10)
//                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
//                    .blendMode(.destinationOut)

                
                
                ZStack{
                    VStack{
                        HStack{
                            VStack{
                                
                            }
                            .frame(width: 134, height: 60)
//                            .background(Color.black)
                            .cornerRadius(14)
                            
                            Spacer()
                            VStack{}
                            .frame(width: 134, height: 60)
//                            .background(Color.black)
                            .cornerRadius(14)
                        }
                        Spacer()
                        
                    }
//                    .padding(20)
                    .frame(maxWidth : .infinity, alignment : .leading)
                    VStack{
                        ZStack{
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
//                                .padding(.horizontal, 20)
//                                .padding(.vertical, 50)
                                .offset(y: 10)
                                .frame(maxWidth : 0.8 * width, maxHeight: 0.6 *  height)
                                .animation(.linear(duration: Double(totalCount)), value: progress)
                            
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(
//                                    LinearGradient(
//                                        gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
//                                        startPoint: .trailing,
//                                        endPoint: .leading
//                                    ),
//                                    lineWidth: 4
//                                )
//                                .frame(maxWidth : 0.8 * width, maxHeight: 0.6 *  height)
//                            //                    .padding()
//                                .background(LinearGradient(
//                                    gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
//                                    startPoint: .trailing,
//                                    endPoint: .leading
//                                ))
//                                .opacity(0.2)
                            
                            VStack{
//                                Circle()
//                                    .fill(LinearGradient(
//                                        gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
//                                        startPoint: .trailing,
//                                        endPoint: .leading
//                                    ))
//                                    .frame(width: 25, height: 25)
//                                
//                                    .padding(40)
                            }
                            .frame(maxWidth : 0.8 * width, maxHeight: 0.6 *  height, alignment: .top)
                            .padding()
//                                .background(.red)
                        }
                        .padding(.top,100)
//                        Spacer()

                    }
                    .frame(maxWidth : .infinity, alignment : .trailing)
                    
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .compositingGroup()
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .onAppear {
                startCountdown()
            }
        }
        .ignoresSafeArea()
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
    FrameOverlayAnimation()
}
