//
//  OnBoarding.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 15/06/25.
//

import SwiftUI

struct BoardingData : Hashable{
    var title : String
    var desc : String
    
    init(_ title: String, _ desc: String) {
        self.title = title
        self.desc = desc
    }
}

struct OnBoardingView : View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var boardingData : [BoardingData] = [
        BoardingData("Realtime Posture Feedback", "Tracks your body joints to guide you and help you proper dumbbell form"),
        BoardingData("Smart Movement Tracking", "Follow an on-screen motion path to guide your arm movement."),
        BoardingData("Perfect for Beginners", "Get step-by-step assistance to build proper dumbbell technique ")
    ]
    
    var body: some View {

        VStack {
            Rectangle()
                .fill(Color.clear)
                .frame(maxWidth : .infinity)
            ForEach(0..<10){_ in
                Spacer()
            }
                

            
            Text("Welcome to \nBumdle")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .frame(maxWidth : .infinity)
            
            HStack(spacing: 20){
                ZStack{
                    VStack{
                        ForEach(0..<7){_ in
                            Spacer()
                        }
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 3)
                        ForEach(0..<7){_ in
                            Spacer()
                        }
                    }
                    .frame(maxHeight : .infinity)
                    

                    VStack{
                        
                        ForEach(0..<boardingData.count, id: \.self){index in
                            Spacer()
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 35, height: 35)
                                .offset(x: 0, y: 0)
                            Spacer()
                                
                                
                        }
                        Spacer()
                    }
                    .frame(maxHeight : .infinity, alignment : .center)
                }
                .frame(maxHeight : .infinity, alignment : .center)

                
                VStack(alignment: .leading){
                    Spacer()
                    ForEach(boardingData, id: \.self){data in
                        Text(data.title)
                            .font(.headline)
                            .padding(.bottom, 5)

                        Text(data.desc)
                            .font(.caption)
                            .padding(.bottom, 10)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                .frame(maxHeight : .infinity)
                
                
            }
            .padding(.horizontal, 30)
            
            ForEach(0..<10){_ in
                Spacer()
            }
            
            
            Button(
                action : {
                    withAnimation{
                        hasCompletedOnboarding = true

                    }
                }
            ){
                Text("Continue")
                    .padding(20)
                    .font(.headline)
                    .frame(maxWidth : .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.gray.opacity(0.3))
                    )
                    .padding(.horizontal, 20)
                    
            }
            
            ForEach(0..<5){_ in
                Spacer()
            }        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(
                gradient: Gradient(colors: [Color("neon"), .darkBg]),
                center: .top,
                startRadius: -10,
                endRadius: 150
            )
            .scaleEffect(x: 1.5, y: 1.0)
        )
        .ignoresSafeArea()
        
        
    
        
    }
    
    
}

#Preview{
    OnBoardingView()
        .environmentObject(RouteManager())
}
