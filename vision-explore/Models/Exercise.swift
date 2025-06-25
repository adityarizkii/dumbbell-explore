//
//  Exercise.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 13/06/25.
//

struct KeyMoment: Hashable {
    var key_image: String
    var key_description: String
}

struct ExerciseDetail: Hashable {
    var about: String
    var key_moment: [KeyMoment]
}

struct Exercise: Hashable {
    var name: String
    var image: String
    var path: String
    var workoutPath : String
    var description: String
    var muscles: [String]
    var detail: ExerciseDetail
    var config : ExerciseAttribute
    var trialGuidance : [TrialGuidance]
}

struct TrialGuidance : Hashable {
    var title : String
    var description : String
}
