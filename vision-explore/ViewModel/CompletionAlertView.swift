import SwiftUI

struct CompletionAlertView: View {
    let onReset: () -> Void
    let repetitionData: [PoseDetectionViewModel.RepetitionData]
    
    var body: some View {
        VStack {
            Text("Selamat!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text("Anda telah menyelesaikan 5 repetisi!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.vertical, 8)
                .foregroundColor(.gray)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(repetitionData, id: \.number) { data in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Repetisi \(data.number)")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            HStack {
                                Text("Naik:")
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.1f", data.upDuration))s")
                                    .foregroundColor(.black)
                            }
                            
                            HStack {
                                Text("Turun:")
                                    .foregroundColor(.gray)
                                Text("\(String(format: "%.1f", data.downDuration))s")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 200)
            
            Button(action: onReset) {
                Text("Mulai Set Baru")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
} 
