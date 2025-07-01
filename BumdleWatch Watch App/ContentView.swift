//
//  ContentView.swift
//  BumdleWatch Watch App
//
//  Created by Muhammad Chandra Ramadhan on 28/06/25.
//

import SwiftUI
import WatchConnectivity
struct ContentView: View {
    @ObservedObject var manager: WatchSessionManager
    @EnvironmentObject var runtimeManager: RuntimeManager

    var body: some View {
        if manager.exerciseDetail.exercise == "" {
            VStack {
                Spacer()
                Image("Icon")
                    .resizable()
                    .frame(width: 50, height:50)
                
                    .cornerRadius(25)
                
                Spacer()
                Text(manager.text)
                Spacer()
            }
            .padding()
            .onAppear {
                runtimeManager.startSession()
            }
        }else{
            ExerciseSession(manager: manager)
        }
        
    }
}


#Preview {
    ContentView(manager : WatchSessionManager() )
}
