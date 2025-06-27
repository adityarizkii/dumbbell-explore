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
                workoutPath: "workout1",
                description: "Build strength in your arms while learning proper form step-by-step.",
                muscles: ["Biceps", "Under Arm"],
                detail: ExerciseDetail(
                    about: "Seated bicep curls are a strength-training exercise that targets your biceps, the muscles in the front part of your upper arms. By sitting down while doing this movement, your body stays more stable, minimizing the involvement of other muscles and allowing for better isolation of the biceps.\n\nThis exercise is great for building arm strength and shaping your biceps, especially if you perform it with slow, controlled movements.",
                    key_moment: [
                        KeyMoment(key_image: "Dumbbell1", key_description: "Stand tall with dumbbells at your sides."),
                        KeyMoment(key_image: "Dumbbell2", key_description: "Curl the dumbbells up, elbows close to your body."),
                        KeyMoment(key_image: "Dumbbell3", key_description: "Hold at the top and squeeze your biceps."),
                    ]
                ),
                config: curl,
                trialGuidance: [
                    TrialGuidance(title: "Follow The Path", description: "Lift the dumbbell along the guided line until it reaches the top point."),
                    TrialGuidance(title: "Reach the Target in Time", description: "Lower the dumbbell according to the countdown."),
                    TrialGuidance(title: "Maintain Your Posture", description: "Keep the green frame aligned to ensure a stable position."),
                ]
            ),
            Exercise(
                name: "Hammer Curl",
                image: "HammerCurl",
                path: "hammer",
                workoutPath: "workout2",
                description: "Focus on control and posture as you train your arms and shoulders.",
                muscles: ["Biceps", "Under Arm"],
                detail: ExerciseDetail(
                    about: "Hammer Curl menargetkan otot biceps dan brachialis dengan posisi telapak tangan netral.",
                    key_moment: [
<<<<<<< Updated upstream
                        KeyMoment(key_image: "Hammer1", key_description: "Posisi awal berdiri, dumbbell di samping tubuh, telapak tangan menghadap ke dalam."),
                        KeyMoment(key_image: "Hammer2", key_description: "Angkat dumbbell ke arah bahu dengan posisi netral."),
//                        KeyMoment(key_image: "Hammer3", key_description: "Tahan di atas, rasakan kontraksi pada lengan bawah."),
                        KeyMoment(key_image: "Hammer3", key_description: "Turunkan perlahan ke posisi awal.")
=======
                        KeyMoment(key_image: "moment1", key_description: "Start standing, dumbbells at sides, palms facing in."),
                        KeyMoment(key_image: "moment2", key_description: "Curl dumbbells up in a neutral grip."),
                        KeyMoment(key_image: "moment3", key_description: "Hold at the top and feel the forearm contraction."),
                        KeyMoment(key_image: "moment4", key_description: "Lower slowly back to start."),
>>>>>>> Stashed changes
                    ]
                ),
                config: hammer,
                trialGuidance: [
                    TrialGuidance(title: "Follow The Path", description: "Lift the dumbbell along the guided line until it reaches the top point."),
                    TrialGuidance(title: "Reach the Target in Time", description: "Lower the dumbbell according to the countdown."),
                    TrialGuidance(title: "Maintain Your Posture", description: "Keep the green frame aligned to ensure a stable position."),
                ]

            ),
            Exercise(
                name: "Forearm Raise",
                image: "ForearmRaise",
                path: "forearm",
                workoutPath: "workout3",
                description: "Improve shoulder stability with guided movement tracking.",
                muscles: ["Shoulder", "Upper Arm"],
                detail: ExerciseDetail(
                    about: "Forearm Raise fokus pada penguatan otot lengan bawah dan pergelangan tangan.",
                    key_moment: [
<<<<<<< Updated upstream
                        KeyMoment(key_image: "Forearm1", key_description: "Posisi awal duduk, lengan di atas paha, telapak tangan menghadap ke atas."),
                        KeyMoment(key_image: "Forearm2", key_description: "Angkat pergelangan tangan ke atas tanpa menggerakkan lengan bawah."),
//                        KeyMoment(key_image: "moment3", key_description: "Tahan di atas, kontraksikan otot lengan bawah."),
                        KeyMoment(key_image: "Forearm3", key_description: "Turunkan perlahan ke posisi awal.")
=======
                        KeyMoment(key_image: "moment1", key_description: "Sit down, forearms on thighs, palms facing up."),
                        KeyMoment(key_image: "moment2", key_description: "Curl wrists upward without moving forearms."),
                        KeyMoment(key_image: "moment3", key_description: "Hold at the top, squeeze your forearms."),
                        KeyMoment(key_image: "moment4", key_description: "Lower slowly to starting position.")
>>>>>>> Stashed changes
                    ]
                ),
                config: raise,
                trialGuidance: [
                    TrialGuidance(title: "Follow The Path", description: "Lift the dumbbell along the guided line until it reaches the top point."),
                    TrialGuidance(title: "Reach the Target in Time", description: "Lower the dumbbell according to the countdown."),
                    TrialGuidance(title: "Maintain Your Posture", description: "Keep the green frame aligned to ensure a stable position."),
                ]

            )
        ]
    }
    
    func getExerciseList() -> [Exercise] {
        return self.exercises
    }
}
