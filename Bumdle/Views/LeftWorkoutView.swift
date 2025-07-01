//
//  LeftWorkoutView.swift
//  Bumdle
//
//  Created by Aditya Rizki on 28/05/25.
//

import SwiftUI

struct LeftWorkoutView: View {
    @EnvironmentObject var exerciseManager : ExerciseManager
    @State var isOn = false
    @StateObject var viewModel  = PoseDetectionViewModel()
    var shoulderPoint: CGPoint?
    var elbowPoint: CGPoint?
    var wristPoint: CGPoint?
    @StateObject var trialViewModel  = TrialViewModel()

    //    var mulai : Bool = false
    var mulai : Bool = true

    @State var showSecondText : Bool = true
    @State var showThirdText : Bool = false
    
    @State var anglePosture : Bool = false
    @State var showArmArea : Bool = false
    @State var isPaused : Bool = false
    @State var rep : Int! = 0

    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width/2
            
            ZStack {
                CameraManager(viewModel: viewModel)
                if let points = viewModel.currentPoints {
                    PoseOverlay(position: viewModel.currentSide, points: points, evaluationColor: viewModel.overlayColor)
                }
                VStack {
                    if viewModel.is90degree {
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
                            .padding(.top, 100)
                        Spacer()
                    }
                    
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
//                if viewModel.showCompletionAlert {
//                    Color.black.opacity(0.5)
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    CompletionAlert(
//                        onReset: {
//                            viewModel.resetExercise()
//                        },
//                        repetitionData: viewModel.repetitionData
//                    )
//                }
                
                
                VStack{
                    HStack{
                        VStack{
//                            Text("00:02")
//                                .font(.largeTitle)
//                                .overlay(
//                                    LinearGradient(
//                                        colors: [Color("Button1"),Color("Button2")],
//                                        startPoint: .leading,
//                                        endPoint: .trailing
//                                    )
//                                )
//                                .mask(
//                                    Text("00:02")
//                                )
//                                .font(.largeTitle)
//                                .font(.system(size: 10, weight: .light, design: .default))
                        }
                        .frame(width: 134, height: 60)
//                        .background(Color.black)
                        .cornerRadius(14)
                        
                        Spacer()
                        VStack{
                            Text("0/\(viewModel.config.repetition)")
                                .font(.largeTitle)
                                .overlay(
                                    LinearGradient(
                                        colors: [Color("Button1"),Color("Button2")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .mask(
                                    Text("\(rep)/\(exerciseManager.exercise.config.repetition)")
                                )
                                .font(.largeTitle)
                                .font(.system(size: 10, weight: .light, design: .default))
                            
                        }
                        .frame(width: 134, height: 60)
                        .background(Color.black)
                        .cornerRadius(14)
                    }
                    Spacer()
                    
                }
                .padding(20)
                .frame(maxWidth : .infinity, alignment : .leading)
                
                //            if viewModel.mulai {
                //                if let firstJoint = viewModel.capturedJoints.first {
                //                    GuideLine(
                //    //                    shoulderPoint: firstJoint.shoulder,
                //                        wristPoint: firstJoint.wrist,
                //                        elbowPoint: firstJoint.elbow
                //                    )
                //                }
                //            }
                
                if viewModel.showArmArea {
                    ZStack{
                        VStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                                            startPoint: .trailing,
                                            endPoint: .leading
                                        ),
                                        lineWidth: 4
                                    )
                                    .frame(maxWidth : 0.8 * width, maxHeight: 0.6 *  height)
                                //                    .padding()
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                                        startPoint: .trailing,
                                        endPoint: .leading
                                    ))
                                    .opacity(0.2)
                                
                                VStack{
                                    Circle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [Color("Button1"), Color("Button2")]),
                                            startPoint: .trailing,
                                            endPoint: .leading
                                        ))
                                        .frame(width: 25, height: 25)
                                    
                                        .padding(40)
                                }
                                .frame(maxWidth : 0.8 * width, maxHeight: 0.6 *  height, alignment: .top)
                                .padding()

                                //                                .background(.red)
                            }
                            .padding(.top,100)
                        }
                        .frame(maxWidth: .infinity, alignment:  (viewModel.currentSide == .right ? .trailing : .leading))


                        
                    }
                    
                    //                    .background()
                }else if viewModel.mulai  && showSecondText{
                    FrameOverlayAnimation()
                        .scaleEffect(x: viewModel.currentSide == .left ? -1 : 1, y: 1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
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

                    if viewModel.mulai{
                        if let firstJoint = viewModel.capturedJoints.first {
                            GuideLine(
                                //                    shoulderPoint: firstJoint.shoulder,
                                
                                trialVM : trialViewModel,
                                isPaused: $isPaused,
                                pointJoint : $viewModel.currentPoints,
                                wj: $viewModel.wristJoint,
                                step : $trialViewModel.step,
                                maxStep : $trialViewModel.maxStep,
                                wristPoint: firstJoint.wrist,
                                elbowPoint: exerciseManager.exercise.path == "forearm" ? firstJoint.shoulder : firstJoint.elbow,
                                shoulderPoint : firstJoint.shoulder,
                                totalCount : 3,
                                repetition : $rep,
                                maxRepetition : exerciseManager.exercise.config.repetition,
                                side : viewModel.currentSide
                            )
//                            .background(.red)
//                            .scaleEffect(x: viewModel.currentSide == .left ? -1 : 1, y: 1)

                        }


                    }else{

                    }
                    
                }
                
                
                if !viewModel.is90degree{
                    SetupOverlay(side : viewModel.currentSide)
                }

                
//                Button{
//                    
//                } label: {
//                    Text("Left Arm Turn!")
//                        
//                }
//                .padding()
//                .foregroundColor(.black)
//                .bold()
//                .background()
//                .cornerRadius(20)
////                
            
                
            }
            .background(
                .black.opacity(0.7)
            )
            .onAppear(){
                viewModel.config = exerciseManager.exercise.config
                // Set untuk latihan lengan kiri (user menghadap kanan)
                viewModel.currentSide = .left
            }
            
        }
        
        
        //.navigationBarBackButtonHidden(true)
    }
}


#Preview {
    LeftWorkoutView()
        .environmentObject(RouteManager())
        .environmentObject(ExerciseManager())
    //        .environmentObject(RouteManager())
} 
