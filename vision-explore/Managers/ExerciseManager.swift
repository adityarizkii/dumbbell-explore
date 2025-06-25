//
//  ExerciseManager.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 25/06/25.
//

import Foundation

class ExerciseManager : ObservableObject{
    var exercise : Exercise
    
    init() {
        self.exercise = Exercise(
            name: "Dumbbell Curl",
            image: "DumbbellCurl",
            path: "dumble",
            workoutPath: "workout1",
            description: "Latihan biceps dengan mengangkat dumbbell ke arah bahu, telapak tangan menghadap atas.",
            muscles: ["Biceps", "Under Arm"],
            detail: ExerciseDetail(
                about: "Seated bicep curls are a strength-training exercise that targets your biceps, the muscles in the front part of your upper arms. By sitting down while doing this movement, your body stays more stable, minimizing the involvement of other muscles and allowing for better isolation of the biceps.\n\nThis exercise is great for building arm strength and shaping your biceps, especially if you perform it with slow, controlled movements.",
                key_moment: [
                    KeyMoment(key_image: "Dumbbell1", key_description: "Posisi awal berdiri tegak, dumbbell di samping tubuh."),
                    KeyMoment(key_image: "Dumbbell2", key_description: "Angkat dumbbell ke arah bahu dengan siku tetap di samping tubuh."),
                    KeyMoment(key_image: "Dumbbell3", key_description: "Tahan di atas, kontraksikan biceps maksimal."),
                ]
            ),
            config: curl,
            trialGuidance: [
                TrialGuidance(title: "Follow The Path", description: "Lift the dumbbell along the guided line until it reaches the top point."),
                TrialGuidance(title: "Reach the Target in Time", description: "Lower the dumbbell according to the countdown."),
                TrialGuidance(title: "Maintain Your Posture", description: "Keep the green frame aligned to ensure a stable position."),
            ]
        )
    }
}
