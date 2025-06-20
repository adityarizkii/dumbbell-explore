//
//  WorkOut.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 16/06/25.
//

import SwiftUI

struct WorkOut: View {
    @StateObject var viewModel = PoseDetectionViewModel()
    @State var isOn = false
    var body: some View {
        
        ZStack {
            CameraPreviewView(viewModel: viewModel)
            if let points = viewModel.currentPoints {
                PoseOverlayView(points: points, evaluationColor: viewModel.overlayColor)
            }
            VStack {
                Text(viewModel.feedbackText)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            
            if viewModel.showCompletionAlert {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                CompletionAlertView(
                    onReset: {
                        viewModel.resetExercise()
                    },
                    repetitionData: viewModel.repetitionData
                )
            }
            
            
            Color.black.opacity(0.7)
                .mask(Rectmask())
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Toggle(isOn : $isOn){
                        Text("Voice")
                            .foregroundStyle(.white)
                    }
                    .colorScheme(.dark)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius : 30)
                            .fill(.black.opacity(0.5))
                    )
                    .tint(LinearGradient(
                        gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width : 120)
                    
                    
                    
                    Spacer()
                    ZStack{
                        Circle()
                            .fill(Color.black)
                            .frame(width: 50, height: 50)
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                    }
                    
                    
                }
                
                
                
                
                Spacer()
                Button{} label: {
                    Text("Start Your First Move")
                        .foregroundStyle(.black)
                        .font(.system(size: 17, weight: .semibold, design: .default ))
                }
                .frame(width: 343, height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
                
            }
            .padding(20)
            .frame(maxWidth : .infinity, alignment : .leading)
            
            
            
        }
        .background(
            .black.opacity(0.7)
        )
    }
}


#Preview {
    WorkOut()
}
