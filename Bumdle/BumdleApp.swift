//
//  vision_exploreApp.swift
//  Bumdle
//
//  Created by Aditya Rizki on 23/05/25.
//

import SwiftUI

@main
struct BumdleApp: App {
    @StateObject var routeManager = RouteManager()
    @StateObject var exercise  = ExerciseManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routeManager)
                .environmentObject(exercise)
        }
    }
}
