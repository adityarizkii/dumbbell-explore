import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PoseDetectionViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                CameraPreviewView(viewModel: viewModel)
                if let points = viewModel.currentPoints {
                    PoseOverlayView(points: points, evaluationColor: viewModel.overlayColor)
                }
                VStack {
                    Text(viewModel.feedbackText)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
                
                
                Circle()
                    .fill(Color.blue)
                    .frame(width :50, height : 50)
                    .position(x : 0.6 * geometry.size.width, y : 0.625 * geometry.size.height)
                
//                ArcShape(startDegrees: 70, endDegrees:320)
//                    .stroke(Color.blue, lineWidth: 4)
//                    .frame(width: 200, height: 100)
//                    .padding()
                
                CurvedLine(curvature: CGFloat(2))
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width : 250, height : 50)
                    .rotationEffect(Angle(degrees: 70))
    
                Circle()
                    .fill(Color.blue)
                    .frame(width :50, height : 50)
                    .position(x : 0.45 * geometry.size.width, y : 0.35 * geometry.size.height)
            }
        }
    }
}

#Preview {
    ContentView()
}
