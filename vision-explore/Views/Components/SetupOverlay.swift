//
//  SetupOverlay.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 25/06/25.
//

import SwiftUI

struct SetupOverlay: View {
    var body: some View {
        ZStack {
            // Background with blur effect
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all) // Full screen color background
//                .blur(radius: 20) // Apply blur effect
            
            // Foreground content
//            VStack {
//                Text("Hello, World!")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .padding()
//            }
            VStack{
                Image("SetupImage2")
                    .resizable()
                    .frame(width: 235, height: 280)
                    .padding(.bottom, 24)
                
                Text("WTurn to the side and make sure your full arm is clearly visible on camera.")
                    .font(.body)
                    .frame(width:300, alignment: .center)
                    .foregroundColor(.white)
                    .padding()
            }
            
        }
    }
}

#Preview {
    SetupOverlay()
}
