//
//  OnBoardingViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

import SwiftUI

class OnBoardingViewModel : ObservableObject{
    private var OBContent : [Boarding]
    @State var index : Int

    init (){
        self.index = 0
        self.OBContent = [
            Boarding(title: "Start Right with Real-Time Guidance", content : "Our app tracks your body joints to guide your arm workouts and help you learn proper dumbbell form—just like a personal trainer would.", path: ""),
            Boarding(title: "Real-Time Feedback That Moves with You", content : "Get instant visual and audio feedback while exercising to correct your posture on the spot—no mirrors, no guesswork.", path: ""),
            Boarding(title: "Get Instant Post-Workout Evaluation", content : "After every set, see how well you performed. The app highlights incorrect movements and gives tips to help you improve next time.", path: "")
        ]
    }
    
    func nextContent(){
        self.index = (self.index + 1) % self.OBContent.count
    }
    
    func getCurrentContent()->Boarding{
        return self.OBContent[self.index]
    }
    
    func getContent()->[Boarding]{
        return self.OBContent
    }
}
