//
//  WorkOut.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 16/06/25.
//

import SwiftUI

struct WorkOut: View {
    @EnvironmentObject var routeManager: RouteManager
    @StateObject var viewModel = PoseDetectionViewModel()
    var shoulderPoint: CGPoint?
    var elbowPoint: CGPoint?
    var wristPoint: CGPoint?
    @State var isOn = false
    var body: some View {
        @State var workoutViewModel : WorkoutViewModel = .init(viewModel : viewModel)

        ZStack {
            CameraPreviewView(viewModel: viewModel)

            workoutViewModel.evaluationLayer()
            
            VStack {
                Text(viewModel.feedbackText)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            
            Color.black.opacity(0.9)
                .mask(Rectmask())
                .overlay(FrameOverlay())
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
                            .frame(width: 39, height: 39)
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .semibold, design: .default ))
                    }
                    .onTapGesture {
                        routeManager.pop()
                        
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
            
            workoutViewModel.handleguidanceLayer()
            
        }
        .background(
            .black.opacity(0.7)
        )
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    WorkOut()
        .environmentObject(RouteManager())
}
