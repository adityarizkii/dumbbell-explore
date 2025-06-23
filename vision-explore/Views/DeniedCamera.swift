//
//  DeniedCamera.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 23/06/25.
//

import SwiftUI

struct DeniedCamera: View {
    var body: some View {
        NavigationStack{
            
            
            VStack{
                Spacer()
                VStack(spacing: 5){
                    Text("Unable  to Access Camera")
                        .font(.title3)
                        .bold()
                    Text("We couldn’t access your camera. Please enable camera access in Settings to continue using this feature.")
                        .frame(maxWidth: 303)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 17, weight: .light, design: .default))
                }
                .foregroundStyle(.white)
                
                Spacer()
                
                HStack(){
                    Button{} label: {
                        Text("Open Setting")
                            .font(.body)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    .frame(width: 343, height: 50)
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
    DeniedCamera()
}
