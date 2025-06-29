//
//  WorkOut.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 16/06/25.
//

import SwiftUI

struct TrialView: View {
    @State var isPaused = false
    @EnvironmentObject var routeManager: RouteManager
    @EnvironmentObject var exerciseManager : ExerciseManager
    @State var speechManger = SpeechManager()
    @State var isOn = true
    @StateObject var viewModel  = PoseDetectionViewModelTrial()
    var shoulderPoint: CGPoint?
    var elbowPoint: CGPoint?
    var wristPoint: CGPoint?
    @StateObject var trialViewModel = TrialViewModel()
    
    var mulai : Bool = true
    @State var showSecondText : Bool = true
    @State var showThirdText : Bool = false
    var body: some View {
        
        
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
            
            ZStack {
                CameraManager(viewModel: viewModel)
                if let points = viewModel.currentPoints {
                    PoseOverlay(position: viewModel.currentSide, points: points, evaluationColor: viewModel.overlayColor)
//                        .onAppear{
//                            print("Posisi \(String(describing: points[.rightWrist]?.x)) y : \(String(describing: points[.rightWrist]?.y))")
//                    }
                    
                    
                }
                VStack {
                    Text(viewModel.feedbackText)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .font(.title3)
                        .overlay(
                            LinearGradient(
                                colors: [Color("Button1"),Color("Button2")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .mask(
                            Text(viewModel.feedbackText)
                        )
                        .font(.title3)
                        .font(.system(size: 10, weight: .light, design: .default))
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding()
                        .padding(.top, 120)
                    Spacer()
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if viewModel.showCompletionAlert {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                    
                    CompletionAlert(
                        onReset: {
                            viewModel.resetExercise()
                        },
                        repetitionData: viewModel.repetitionData
                    )
                }
                
                
                
                
                //            if viewModel.mulai {
                //                if let firstJoint = viewModel.capturedJoints.first {
                //                    GuideLine(
                //    //                    shoulderPoint: firstJoint.shoulder,
                //                        wristPoint: firstJoint.wrist,
                //                        elbowPoint: firstJoint.elbow
                //                    )
                //                }
                //            }
                
                if !viewModel.mulai {
                    ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                                                        startPoint: .trailing,
                                                        endPoint: .leading
                                                    )
                                                    .opacity(0.3),
                    //                                lineWidth: 4
                                                )
                                                .frame(maxWidth : 0.8 * width/2, maxHeight: 0.5 *  height)
                                            //                    .padding()
                                            //                    .background(Color.red)
                    //                        VStack{
                    //                            Circle()
                    //                                .fill(LinearGradient(
                    //                                    gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                    //                                    startPoint: .trailing,
                    //                                    endPoint: .leading
                    //                                ))
                    //                                .frame(width: 25, height: 25)
                    //
                    //                        }
                                            

                                        }
                                        .padding(.trailing, 40)
                                        .padding(.top, 40)
                                        .frame(maxWidth : .infinity, maxHeight: .infinity, alignment: .trailing)



                }else if viewModel.mulai  && showSecondText{
                    TrialOverlay()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        withAnimation {
                                            self.showSecondText = false
                                            showThirdText = true
                                            
                                        }
                                    }
                                    
                                }
                            }
                        }
                }
                else if showThirdText{
                    if let firstJoint = viewModel.capturedJoints.first {
                        TrialGuideLine(
                            //                    shoulderPoint: firstJoint.shoulder,
                            trialVM : trialViewModel,
                            isPaused: $isPaused,
                            pointJoint : $viewModel.currentPoints,
                            wj: $viewModel.wristJoint,
                            step : $trialViewModel.step,
                            maxStep : $trialViewModel.maxStep,
                            wristPoint: firstJoint.wrist,
                            elbowPoint: firstJoint.elbow
                            
                            
                        )
                    }
                }
                
                
                //Overlay
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
                        .onChange(of : isOn){
                            trialViewModel.isMuted = !isOn
                            
                            if !isOn{
                                
                                trialViewModel.speechManager.stop()
                            }
                        }
                        
                        Spacer()
                        ZStack{
                            Circle()
                                .fill(Color.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .semibold, design: .default ))
                        }
                        .onTapGesture {
                            routeManager.pop()
                            
                        }
                        
                    }
                    
                    Spacer()
                    if trialViewModel.step < trialViewModel.trialGuidance.count ?? 0{
                        VStack{
                            Text(trialViewModel.getCurrentGuidance()?.title ?? "")
                                .multilineTextAlignment(.center)
                                .font(.title.bold())
                                .frame(maxWidth : .infinity, alignment: .center)
                            Text(trialViewModel.getCurrentGuidance()?.description ?? "")
                                .multilineTextAlignment(.center)
                                .frame(maxWidth : .infinity, alignment: .center)
                        }
                    }else{
                        Button{
                            routeManager.push("workout")
                        } label: {
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
                    
                    
                }
                .padding(20)
                .frame(maxWidth : .infinity, alignment : .leading)
                
                
                
            }
            .background(
                .black.opacity(0.7)
            )
            .onAppear(){
                viewModel.config = exerciseManager.exercise.config
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            trialViewModel.isMuted = isOn
            trialViewModel.updateGuidance( exerciseManager.exercise.trialGuidance)
        }
    }
}


#Preview {
    TrialView()
        .environmentObject(RouteManager())
        .environmentObject(ExerciseManager())
}
