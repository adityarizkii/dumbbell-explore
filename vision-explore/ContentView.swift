import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PoseDetectionViewModel()
    @State var isOn = false
    var body: some View {
        
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
            
            if viewModel.showCompletionAlert {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                CompletionAlertView(
                    onReset: {
                        viewModel.resetExercise()
                    },
                    repetitionData: viewModel.repetitionData
                )
            }
            Color.black.opacity(0.7)
                .mask(Rectmask())
                .ignoresSafeArea()
            
            VStack{
                
                HStack{
                    Toggle(isOn : $isOn){
                        Text("Voice")
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius : 30)
                            .fill(.black.opacity(0.5))
                    )
                    .frame(width : 120)
                    
                    
                    Spacer()
                    Image(systemName: "info.circle")
                        .font(.largeTitle)
                    Image(systemName: "info.circle")
                        .font(.largeTitle)
                    
                }
                
                
                
                
                Spacer()
                Button(action : {
                    
                }){
                    Text("Start")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth : .infinity)
                        .background(
                            RoundedRectangle(cornerRadius : 20)
                                .fill(Color.blue)
                        )
                }

            }
            .padding(20)
            .frame(maxWidth : .infinity, alignment : .leading)
            
            

        }
        .background(
            .black.opacity(0.7)
        )
    }
}

#Preview {
    ContentView()
}
