//
//  OnBoarding.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 15/06/25.
//

import SwiftUI

struct OnBoarding : View {
    @State var index = 0
    
    func next(){
        index = (index + 1) % OBContent.count
    }
    
    var body: some View {
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
            
            Text(OBContent[index].title)
                .font(.title3.bold())
                .frame(maxWidth : .infinity, alignment : .leading)
            
            Text(OBContent[index].content)
                .font(.caption)
                .frame(maxWidth : .infinity, alignment : .leading)
            
            Spacer()

            Button(action: {
                withAnimation(.default){
                    next()

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
    OnBoarding()
}
