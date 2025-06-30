import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding{
            HomeView()
        }else{
            OnBoardingView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RouteManager())
    
}
