//
//  OnBoarding.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 15/06/25.
//

import SwiftUI

struct OnBoardingView : View {
    
    var body: some View {
        var onBoardingViewModel : OnBoardingViewModel = .init()

        VStack{
            Spacer()
            Image(systemName : "dumbbell")
                .font(.system(size : 120))
                .padding(50)
                .background(
                    Circle()
                        .fill(.gray.opacity(0.2))
                )
            Spacer()
            
            Text(onBoardingViewModel.getCurrentContent().title)
                .font(.title3.bold())
                .frame(maxWidth : .infinity, alignment : .leading)
            Text(onBoardingViewModel.getCurrentContent().content)
                .font(.caption)
                .frame(maxWidth : .infinity, alignment : .leading)
            Spacer()

            Button(action: {
                withAnimation(.default){
                    onBoardingViewModel.nextContent()
                }
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth : .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .preferredColorScheme(.dark)
        .padding(20)
        .background(Color("DarkBg"))

    }
    
}

#Preview{
    OnBoardingView()
        .environmentObject(RouteManager())
}
