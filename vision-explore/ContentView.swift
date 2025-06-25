import SwiftUI

struct ContentView: View {
    var body: some View {
        //WorkoutView()
        HomeView()
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteManager())
    
}
