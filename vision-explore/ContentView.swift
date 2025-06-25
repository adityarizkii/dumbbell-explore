import SwiftUI

struct ContentView: View {
    var body: some View {
        WorkoutView()
            .environmentObject(RouteManager())
            .environmentObject(ExerciseManager())
        //HomeView()
            //.preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteManager())
    
}
