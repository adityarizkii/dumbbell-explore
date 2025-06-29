//
//  vision_exploreApp.swift
//  vision-explore
//
//  Created by Aditya Rizki on 23/05/25.
//

import SwiftUI

@main
struct vision_exploreApp: App {
    @StateObject var routeManager = RouteManager()
    var phoneSessionManager = PhoneSessionManager()
    @StateObject var exercise  = ExerciseManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routeManager)
                .environmentObject(exercise)
                .environmentObject(phoneSessionManager)
        }
    }
}
