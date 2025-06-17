import SwiftUI

struct ContentView: View {
    @StateObject private var route = RouteManager()
    var body: some View {
        HomeView()
     
    }
}

#Preview {
    ContentView()
    
}
