import SwiftUI
import AVKit

struct VideoPlayerView: View {
    // Untuk video dari URL
//     let videoURL = URL(string: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4")!
    
    // Untuk video dari bundle (file lokal)
    let videoURL = Bundle.main.url(forResource: "sample-video", withExtension: "mp4")!
    
    var body: some View {
        VStack {
            // Video Player dengan kontrol standar
            VideoPlayer(player: AVPlayer(url: videoURL))
                .frame(height: 300)
                .cornerRadius(12)
                .padding()
            
            // Video Player tanpa kontrol (custom controls)
            VideoPlayer(player: AVPlayer(url: videoURL))
                .frame(height: 200)
                .cornerRadius(12)
                .padding()
                .disabled(true) // Menonaktifkan kontrol default
            
            // Tombol kontrol custom
            HStack(spacing: 20) {
                Button("Play") {
                    // Logic untuk play video
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                Button("Pause") {
                    // Logic untuk pause video
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(8)
            }
        }
        .background(Color(hex: "#1a1a1a"))
    }
}

#Preview {
    VideoPlayerView()
} 
