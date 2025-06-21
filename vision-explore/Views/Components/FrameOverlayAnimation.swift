//
//  FrameOverlay.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 21/06/25.
//

import SwiftUI

struct FrameOverlay: View {
    
    
    var body: some View {
        GeometryReader { geo in
            let frameHeight = geo.size.height * 0.8
//            let frameHeight: CGFloat = 680
            let cornerRadius: CGFloat = 15

            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
                    .blendMode(.destinationOut)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .trim(from: 0.1, to: 0.4)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                            startPoint: .trailing,
                            endPoint: .leading
                            
                        ),
                        lineWidth: 4
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .trim(from: 0.6, to: 0.9)
                    .stroke(
                       LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 4
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
            }
//            .compositingGroup()
            .frame(width: geo.size.width, height: geo.size.height) // Ensure full use of GeometryReader's available space// Optional: Add background color for better visualization
            .compositingGroup()
            .position(x: geo.size.width / 2, y: geo.size.height / 2) 
        }
        .ignoresSafeArea()

    }
}

#Preview {
    FrameOverlay()
}
