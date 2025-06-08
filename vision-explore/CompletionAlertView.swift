import SwiftUI

struct CompletionAlertView: View {
    let onReset: () -> Void
    
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