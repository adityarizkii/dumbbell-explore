//
//  WorkoutViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var viewModel : PoseDetectionViewModel!
    
    init(viewModel: PoseDetectionViewModel!) {
        self.viewModel = viewModel
    }
    
    func evaluationLayer()-> some View{
        ZStack{
            if let points = viewModel.currentPoints {
                PoseOverlayView(points: points, evaluationColor: viewModel.overlayColor)
            }
            
            if viewModel.showCompletionAlert {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                CompletionAlertView(
                    onReset: {
                        self.viewModel.resetExercise()
                    },
                    repetitionData: viewModel.repetitionData
                )
            }
        }
    }
    
    func handleguidanceLayer()-> some View{
        VStack{
            if let firstJoint = self.viewModel.capturedJoints.first {
                 GuidedLineView(
    //                    shoulderPoint: firstJoint.shoulder,
                    wristPoint: firstJoint.wrist,
                    elbowPoint: firstJoint.elbow
                )
            }
        }
        
    }
}
