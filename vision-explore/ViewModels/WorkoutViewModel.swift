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
                PoseOverlay(position: viewModel.currentSide, points: points, evaluationColor: viewModel.overlayColor)
            }
            
            if viewModel.showCompletionAlert {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                CompletionAlert(
                    onReset: {
                        self.viewModel.resetExercise()
                    },
                    repetitionData: viewModel.repetitionData
                )
            }
        }
    }
    
<<<<<<< HEAD
    
=======
    func handleguidanceLayer()-> some View{
        VStack{
            if let firstJoint = self.viewModel.capturedJoints.first {
                 GuideLine(
    //                    shoulderPoint: firstJoint.shoulder,
                    wristPoint: firstJoint.wrist,
                    elbowPoint: firstJoint.elbow,
                    side : self.viewModel.currentSide,
                    
                )
            }
        }
        
    }
>>>>>>> c698ccbb3e1766b407f9f2b99a2543cd982c44d3
}
