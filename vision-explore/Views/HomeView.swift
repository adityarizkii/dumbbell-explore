//
//  HomeView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 13/06/25.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var routeManager: RouteManager
    
    var body: some View {
        @State var homeViewModel: HomeViewModel = .init(routeManager: routeManager)

        NavigationStack(path : $routeManager.path){
            ZStack {
                ZStack{
                    HStack{
                        Spacer()
                        Image("homeImage")
                            .resizable()
                            .frame(width: 350, height: 400)
                    }
                    .padding(.top, 80)
                    
                    VStack(alignment:.leading, spacing:10){
                        Text("Start Your\nPosture Journey")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .default))
                        
                        Text("Track your form, improve your \nposture, and build\nconfidence—one rep at a time.")
                            .font(.system(size: 14, weight: .light, design: .default))
                    }
                    .padding(.top, 100)
                    .padding(.leading, 30)
                    .frame(maxWidth: .infinity,maxHeight: 400, alignment: .topLeading)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                
                
                VStack{
                    Text("Select Exercises")
                        .font(.headline)
                        .foregroundColor(.white)
                        
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    homeViewModel.showExerciseList()
                    
                }
                .padding()
                .frame(maxHeight:.infinity, alignment: .bottom)
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [Color("neon"), .darkBg]),
                    center: .top,
                    startRadius: -10,
                    endRadius: 150
                )
                .scaleEffect(x: 1.5, y: 1.0)
            )
            .ignoresSafeArea()
            .navigationDestination(for: String.self) { path in
                AnyView(routeManager.getViewFromRoute(path: path))
            }
        }
        .onAppear(){
            homeViewModel = HomeViewModel(routeManager : routeManager)
        }
      
    }
}

#Preview {
    HomeView()
        .environmentObject(RouteManager())
}
