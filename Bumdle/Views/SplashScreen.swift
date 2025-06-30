//
//  SplashScreen.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 30/06/25.
//

import SwiftUI


struct SplashScreen: View {
    var body: some View {
        VStack {
            Image("Icon")
            Text("Bumdle")
                .font(.largeTitle.bold())
                .padding()
            
        }
        .frame(maxWidth : .infinity, maxHeight : .infinity)
        .background(.darkBg)
        .preferredColorScheme(.dark)
    }
}


#Preview {
    SplashScreen()
}
