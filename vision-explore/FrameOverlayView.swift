//
//  FrameOverlayView.swift
//  vision-explore
//
//  Created by Aditya Rizki on 28/05/25.
//

import SwiftUI

struct FrameOverlayView: View {
    // Frame padding configuration
    private let horizontalPadding: CGFloat = 20  // Left and right padding
    private let topPadding: CGFloat = 64         // Top padding
    private let bottomPadding: CGFloat = 80      // Bottom padding
    private let frameOpacity: CGFloat = 0.8      // Frame opacity
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Top frame
                Rectangle()
                    .fill(Color.black.opacity(frameOpacity))
                    .frame(height: topPadding)
                    .position(x: geometry.size.width / 2, y: topPadding / 2)
                
                // Bottom frame
                Rectangle()
                    .fill(Color.black.opacity(frameOpacity))
                    .frame(height: bottomPadding)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - bottomPadding / 2)
                
                // Left frame
                Rectangle()
                    .fill(Color.black.opacity(frameOpacity))
                    .frame(width: horizontalPadding)
                    .position(x: horizontalPadding / 2, y: geometry.size.height / 2)
                
                // Right frame
                Rectangle()
                    .fill(Color.black.opacity(frameOpacity))
                    .frame(width: horizontalPadding)
                    .position(x: geometry.size.width - horizontalPadding / 2, y: geometry.size.height / 2)
                
                // Stroke image in the center
                Image("stroke-right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        width: geometry.size.width - (horizontalPadding * 2) - 50, // Slightly smaller than frame
                        height: geometry.size.height - (topPadding + bottomPadding) - 50
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: (topPadding + (geometry.size.height - topPadding - bottomPadding) / 2 + 40)
                    )
            }
        }
    }
}

#Preview {
    ZStack {
        Color.gray // Background for preview
        FrameOverlayView()
    }
} 
