//
//  SetupCameraView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 22/06/25.
//

import SwiftUI

struct SetupCameraView: View {
    var body: some View {
        NavigationStack{
            
            
            VStack{
                Spacer()
                VStack(spacing: 5){
                    Text("First time here?")
                        .font(.largeTitle)
                        .bold()
                    Text("Let’s explore what you can do with the app.")
                        .font(.system(size: 17, weight: .light, design: .default))
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                HStack(spacing: 28){
                    Text("Skip Guding")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    
                    Button{} label: {
                        Text("Start Guiding")
                            .font(.body)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    .frame(width: 198, height: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
                }
                .padding(.bottom,14)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.darkBg)
        }
    }
}

#Preview {
    SetupCameraView()
}
