import SwiftUI

struct ContentView: View {
    var body: some View {
    //WorkoutView()
           
    HomeView()
    //        //.preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteManager())
    
}
