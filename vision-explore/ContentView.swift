import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
        //WorkoutView()
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteManager())
    
}
