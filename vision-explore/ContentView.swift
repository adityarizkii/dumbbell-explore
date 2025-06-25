import SwiftUI

struct ContentView: View {
    var body: some View {
        WorkoutView()
        //WorkoutView()
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteManager())
    
}
