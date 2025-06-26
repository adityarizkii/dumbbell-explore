//
//  FinishView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 20/06/25.
//

import SwiftUI

struct FinishView: View {
    @EnvironmentObject var routeManager : RouteManager
    var body: some View {
            VStack {
                Spacer()
                VStack(spacing: 10){
                    Text("Well Done!")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    Text("You've completed the exercise with great form. Keep practicing to build strength and improve your posture.")
                        .foregroundStyle(.white)
                        .font(.system(size: 17, weight: .light, design: .default ))
                        .frame(maxWidth: 300)
                        
                }
                
                Spacer()
                
                VStack(spacing: 16){
                    Button{} label: {
                        Text("Repeat this exercise")
                            .foregroundStyle(.white)
                            .font(.system(size: 17, weight: .semibold, design: .default ))
                    }
                    .frame(width: 343, height: 50)
                    .background(Color("gray"))
                    .cornerRadius(14)
                    
                    Button{
                        routeManager.clear()
                    } label: {
                        Text("Done")
                            .foregroundStyle(.black)
                            .font(.system(size: 17, weight: .semibold, design: .default ))
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
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .navigationBarBackButtonHidden(true)

        }
}

#Preview {
    FinishView()
        .environmentObject(RouteManager())
}
