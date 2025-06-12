//
//  Exercise.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 11/06/25.
//

struct Exercise : Hashable{
    var name : String
    var image : String
    var path : String
    var description : String
}

var exercises : [Exercise] = [
    Exercise(name: "Dumbbell Curl", image: "DumbbellCurl", path: "dumble", description: "Latihan biceps dengan mengangkat dumbbell ke arah bahu, telapak tangan menghadap atas."),
    Exercise(name: "Hammer Curl", image: "HammerCurl", path: "camera", description: "Variasi curl dengan telapak tangan netral. Melatih biceps dan otot lengan samping."),
    Exercise(name: "Forearm Raise", image: "ForearmRaise", path: "camera", description: "Latihan lengan bawah dengan mengangkat pergelangan tangan sambil memegang dumbbell."),
]

