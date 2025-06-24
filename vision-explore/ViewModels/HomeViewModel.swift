//
//  HomeViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    var exercises : [Exercise]
    
    
    init() {
        //Daftar workout 
        self.exercises = [
            Exercise(name: "Dumbbell Curl", image: "DumbbellCurl", path: "dumble", description: "Latihan biceps dengan mengangkat dumbbell ke arah bahu, telapak tangan menghadap atas.",muscles: ["Biceps","Under Arm"]),
            Exercise(name: "Hammer Curl", image: "HammerCurl", path: "camera", description: "Variasi curl dengan telapak tangan netral. Melatih biceps dan otot lengan samping.",muscles: ["Biceps","Under Arm"]),
            Exercise(name: "Forearm Raise", image: "ForearmRaise", path: "camera", description: "Latihan lengan bawah dengan mengangkat pergelangan tangan sambil memegang dumbbell.",muscles: ["Shoulder","Upper Arm"]),
        ]
    }
    
    func getExerciseList()->[Exercise]{
        return self.exercises
    }
}
