//
//  TestSound.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 22/06/25.
//

//
//  TestSound.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 22/06/25.
//
import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var exerciseManager : ExerciseManager
    @State var isOn = false
    @StateObject var viewModel  = PoseDetectionViewModel()
    var shoulderPoint: CGPoint?
    var elbowPoint: CGPoint?
    var wristPoint: CGPoint?
    
    //    var mulai : Bool = false
    var mulai : Bool = true
    @State var showSecondText : Bool = true
    @State var showThirdText : Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width/2
            
            ZStack {
                CameraManager(viewModel: viewModel)
                if let points = viewModel.currentPoints {
                    PoseOverlay(points: points, evaluationColor: viewModel.overlayColor)
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
                
                
                VStack{
                    HStack{
                        VStack{
                            Text("00:02")
                                .font(.largeTitle)
                                .overlay(
                                    LinearGradient(
                                        colors: [Color("Button1"),Color("Button2")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .mask(
                                    Text("00:02")
                                )
                                .font(.largeTitle)
                                .font(.system(size: 10, weight: .light, design: .default))
                        }
                        .frame(width: 134, height: 60)
                        .background(Color.black)
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
                                    Text("0/\(viewModel.config.repetition)")
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
                
                if !viewModel.mulai {
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
                        .frame(maxWidth : .infinity, alignment : .trailing)

                    }
                }else if viewModel.mulai  && showSecondText{
                    FrameOverlayAnimation()
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
                        GuideLine(
                            //                    shoulderPoint: firstJoint.shoulder,
                            wristPoint: firstJoint.wrist,
                            elbowPoint: firstJoint.elbow
                        )
                    }
                }
                
                
                
            }
            .background(
                .black.opacity(0.7)
            )
            .onAppear(){
                viewModel.config = exerciseManager.exercise.config
            }
            
        }
        
        
        //.navigationBarBackButtonHidden(true)
    }
}


#Preview {
    WorkoutView()
        .environmentObject(RouteManager())
        .environmentObject(ExerciseManager())
    //        .environmentObject(RouteManager())
}



//
//import SwiftUI
//import AVFoundation
//
//struct TestSound: View {
//    @State private var currentIndex = 0
//    private let phrases = [
//        "Test sound capability",
//        "Voice guidance enabled",
//        "Speaking now...",
//        "Hello, welcome!",
//        "We will guide you to perform the good posture while doing exercise using dumbbell",
//        "Adjust your elbow to the fix position",
//        "Make sure your shoulder is relaxed",
//    ]
//    @State private var timer: Timer? = nil
//
//    private let synthesizer = AVSpeechSynthesizerDelegateWrapper()
//    @State var isVoiceOn = true
//
//    var body: some View {
//        VStack {
//
//            HStack{
//                Toggle(isOn : $isVoiceOn){
//                    Text("Sound")
//                        .foregroundStyle(.white)
//                }
//                .colorScheme(.dark)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 10)
//                .background(
//                    RoundedRectangle(cornerRadius : 30)
//                        .fill(.black.opacity(0.5))
//                )
//                .tint(LinearGradient(
//                    gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
//                    startPoint: .leading,
//                    endPoint: .trailing
//                ))
//                .frame(width : 130)
//
//
//
//                Spacer()
//                ZStack{
//                    Circle()
//                        .fill(Color.black)
//                        .frame(width: 39, height: 39)
//                    Image(systemName: "xmark.circle")
//                        .foregroundStyle(.white)
//                        .font(.system(size: 16, weight: .semibold, design: .default ))
//                }
//
//
//            }
//            Spacer()
//            Text(phrases[currentIndex])
//                .font(.title2)
//                .bold()
//                .foregroundStyle(.white)
//            Spacer()
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.darkBg)
//        .onAppear {
//            synthesizer.startSpeaking(phrases: phrases, onUpdate: { index in
//                currentIndex = index
//            }, voiceEnabled: {
//                isVoiceOn
//            })
//        }
//        .onChange(of: isVoiceOn) {
//            if !isVoiceOn {
//                synthesizer.stop()
//            }
//        }
//    }
//
//}
//
//class AVSpeechSynthesizerDelegateWrapper: NSObject, AVSpeechSynthesizerDelegate {
//    private let synthesizer = AVSpeechSynthesizer()
//    private var phrases: [String] = []
//    private var currentIndex = 0
//    private var onUpdate: ((Int) -> Void)?
//    private var isVoiceEnabled: (() -> Bool)?
//
//    func startSpeaking(phrases: [String],
//                       onUpdate: @escaping (Int) -> Void,
//                       voiceEnabled: @escaping () -> Bool) {
//        self.phrases = phrases
//        self.onUpdate = onUpdate
//        self.isVoiceEnabled = voiceEnabled
//        self.currentIndex = 0
//        synthesizer.delegate = self
//        speakNext()
//    }
//
//    func speakNext() {
//        guard currentIndex < phrases.count else { return }
//
//        onUpdate?(currentIndex)
//
//        if isVoiceEnabled?() == true {
//            let utterance = AVSpeechUtterance(string: phrases[currentIndex])
//            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//            utterance.rate = 0.5
//            synthesizer.speak(utterance)
//        } else {
//            // Skip speaking but simulate end of utterance
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.advance()
//            }
//        }
//    }
//
//    func advance() {
//        currentIndex += 1
//        speakNext()
//    }
//
//    func stop() {
//        synthesizer.stopSpeaking(at: .immediate)
//    }
//
//    // Delegate: Called when one phrase finishes
//    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        advance()
//    }
//}
//
//
//#Preview {
//    HomeView()
//}
