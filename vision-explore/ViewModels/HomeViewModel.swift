//
//  HomeViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    var exercises: [Exercise]
    
    init() {
        self.exercises = [
            Exercise(
                name: "Dumbbell Curl",
                image: "DumbbellCurl",
                path: "dumble",
                description: "Latihan biceps dengan mengangkat dumbbell ke arah bahu, telapak tangan menghadap atas.",
                muscles: ["Biceps", "Under Arm"],
                detail: ExerciseDetail(
                    about: "Seated bicep curls are a strength-training exercise that targets your biceps, the muscles in the front part of your upper arms. By sitting down while doing this movement, your body stays more stable, minimizing the involvement of other muscles and allowing for better isolation of the biceps.\n\n This exercise is great for building arm strength and shaping your biceps, especially if you perform it with slow, controlled movements.",
                    key_moment: [
                        KeyMoment(key_image: "moment1", key_description: "Posisi awal berdiri tegak, dumbbell di samping tubuh."),
                        KeyMoment(key_image: "moment2", key_description: "Angkat dumbbell ke arah bahu dengan siku tetap di samping tubuh."),
                        KeyMoment(key_image: "moment3", key_description: "Tahan di atas, kontraksikan biceps maksimal."),
                        KeyMoment(key_image: "moment4", key_description: "Turunkan dumbbell perlahan ke posisi awal.")
                    ]
                )
            ),
            Exercise(
                name: "Hammer Curl",
                image: "HammerCurl",
                path: "camera",
                description: "Variasi curl dengan telapak tangan netral. Melatih biceps dan otot lengan samping.",
                muscles: ["Biceps", "Under Arm"],
                detail: ExerciseDetail(
                    about: "Hammer Curl menargetkan otot biceps dan brachialis dengan posisi telapak tangan netral.",
                    key_moment: [
                        KeyMoment(key_image: "moment1", key_description: "Posisi awal berdiri, dumbbell di samping tubuh, telapak tangan menghadap ke dalam."),
                        KeyMoment(key_image: "moment2", key_description: "Angkat dumbbell ke arah bahu dengan posisi netral."),
                        KeyMoment(key_image: "moment3", key_description: "Tahan di atas, rasakan kontraksi pada lengan bawah."),
                        KeyMoment(key_image: "moment4", key_description: "Turunkan perlahan ke posisi awal.")
                    ]
                )
            ),
            Exercise(
                name: "Forearm Raise",
                image: "ForearmRaise",
                path: "camera",
                description: "Latihan lengan bawah dengan mengangkat pergelangan tangan sambil memegang dumbbell.",
                muscles: ["Shoulder", "Upper Arm"],
                detail: ExerciseDetail(
                    about: "Forearm Raise fokus pada penguatan otot lengan bawah dan pergelangan tangan.",
                    key_moment: [
                        KeyMoment(key_image: "moment1", key_description: "Posisi awal duduk, lengan di atas paha, telapak tangan menghadap ke atas."),
                        KeyMoment(key_image: "moment2", key_description: "Angkat pergelangan tangan ke atas tanpa menggerakkan lengan bawah."),
                        KeyMoment(key_image: "moment3", key_description: "Tahan di atas, kontraksikan otot lengan bawah."),
                        KeyMoment(key_image: "moment4", key_description: "Turunkan perlahan ke posisi awal.")
                    ]
                )
            )
        ]
    }
    
    func getExerciseList() -> [Exercise] {
        return self.exercises
    }
}
