//
//  VideoPlayer.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 24/06/25.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    // Untuk video dari URL
//     let videoURL = URL(string: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4")!
    
    // Untuk video dari bundle (file lokal)
    let videoURL = Bundle.main.url(forResource: "dumbbell", withExtension: "mp4")!
    
    var body: some View {
            // Video Player dengan kontrol standar
            VideoPlayer(player: AVPlayer(url: videoURL))
                .frame(height: 200)
                .cornerRadius(12)
                .padding()
            
            

    }
}

#Preview {
    VideoPlayerView()
}
