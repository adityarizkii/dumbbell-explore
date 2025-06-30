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
    var phoneSessionManager = PhoneSessionManager()
    @StateObject var exercise  = ExerciseManager()
    
    @State var isActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isActive{
                ContentView()
                    .environmentObject(routeManager)
                    .environmentObject(exercise)
                    .environmentObject(phoneSessionManager)
                    .preferredColorScheme(.dark)
            }else {
                SplashScreen()
                    .preferredColorScheme(.dark)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isActive = true
                        }
                    }
            }
           
        }
    }
}
