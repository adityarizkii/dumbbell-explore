//
//  HomeView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 13/06/25.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var routeManager: RouteManager
    @EnvironmentObject var exerciseManager: ExerciseManager

    var body: some View {
        @State var homeViewModel = HomeViewModel()

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

                    ForEach(homeViewModel.getExerciseList(), id: \.name) { exercise in
                        VStack(spacing: 21){
                            VStack{
                                HStack{
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(exercise.name)
                                            .foregroundColor(.white)
                                            .font(.body.bold())
                                            .font(.system(size: 17, weight: .bold, design: .default))
                                        Text(exercise.description)
                                            .foregroundColor(.white)
                                            .font(.system(size: 12,weight: .light, design: .default))
                                            .padding(.bottom, 5)

                                        HStack{
                                            ForEach(exercise.muscles, id: \.self){index in
                                                Text(index)
                                                    .font(.system(size: 10, weight: .light)) // optional styling
                                                    .overlay(
                                                        LinearGradient(
                                                            colors: [Color("Button1"),Color("Button2")],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .mask(
                                                        Text(index)
                                                            .font(.system(size: 10, weight: .light))
                                                    )
                                                    .font(.system(size: 10, weight: .light, design: .default))
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical,3)
                                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle(lineWidth: 0.5))
                                                        .foregroundColor(.gray),alignment: .center)
                                            
                                            }
                                        }
                                        
                                        
                                        
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        ZStack{
                                            Image(exercise.image)
                                                .resizable()
                                                .frame(width: 150, height: 150)
                                            VStack{
                                                Spacer()
                                                Button {
                                                    exerciseManager.exercise = exercise
                                                    exerciseManager.side = .left
                                                    self.routeManager.push("tutorial")
                                                    
                                                    print("Route : \(exercise.path)")
                                                } label: {
                                                    Text("Start Exercise")
                                                        .foregroundStyle(Color.black)
                                                        .font(.system(size: 15, weight: .semibold, design: .default))
                                                        .padding(.horizontal)
                                                    
                                                }
                                                .frame( maxHeight: 30)
                                                .background(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .cornerRadius(10)
                                                .padding(.bottom,15)
                                            }
                                            .frame(maxHeight: .infinity)
                                            
                                        }
                                    }
                                    
                                    
                                }
                                .frame(maxWidth: .infinity)
            //                                .background(.gray.opacity(0.2))
                                
                            }
                            .frame(maxWidth: .infinity, maxHeight: 132)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(RadialGradient(
                                gradient: Gradient(colors: [Color("neon"), .darkgreen]),
                                center: .topTrailing,
                                startRadius: 0,
                                endRadius: 200
                            ))
                            .cornerRadius(14)
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
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
            .navigationDestination(for: String.self) { routeName in
                routeManager.getView(for: routeName)
            }
        }
        .onAppear(){
            homeViewModel = HomeViewModel()
        }
      
    }
}

#Preview {
    HomeView()
        .environmentObject(RouteManager())
}
