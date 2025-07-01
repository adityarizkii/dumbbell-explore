//
//  ExerciseSession.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 29/06/25.
//

import SwiftUI

struct ExerciseSession: View {
    @ObservedObject var manager: WatchSessionManager
    @EnvironmentObject var runtimeManager: RuntimeManager

    var body: some View {
        VStack{
            Image("Icon")
                .resizable()
                .frame(width: 35, height:35)
                .cornerRadius(25)
            Text("Workout session")
                .font(.headline)
                .padding(.bottom, )
            Divider()
                .padding(.horizontal, 30)
            
            Text(manager.exerciseDetail.feedback)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .font(.title2.bold())
                .padding(.bottom)
            HStack{
                Text("Repetition : ")
                Text("\(manager.exerciseDetail.repetitions)")
                    .font(.title3.bold())
            }
            Spacer()
        }
        .onAppear {
            runtimeManager.startSession()
        }
    }
}

#Preview {
    ExerciseSession(manager : WatchSessionManager())
}
