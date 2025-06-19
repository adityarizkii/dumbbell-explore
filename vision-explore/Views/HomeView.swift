//
//  HomeView.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 13/06/25.
//

import SwiftUI


struct HomeView: View {
    @StateObject var routeManager = RouteManager()
    
    var body: some View {
        NavigationStack(path : $routeManager.path){
            ZStack {
                Color(.black)
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("neon"), location: 0.0),
                        .init(color: .black, location: 0.3),
                        .init(color: .black, location: 0.7),
                        .init(color: Color("neon"), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(1)
                
                
                VStack{
                    Text("Workout")
                        .foregroundStyle(.white)
                        .font(.system(size: 24, weight: .bold, design: .default))
                    
                    
                    VStack{
                        HStack{
                            Spacer()
                            ZStack {
                                
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                                
                                Circle()
                                    .trim(from: 0.0, to: 0.8)
                                    .stroke(
                                        Color("Button1"),
                                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))

                                Text("\(Int(0.8 * 100))%")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 84, height: 84)

                            Spacer()
                            VStack(alignment: .leading, spacing: 5){
                                Text("Workout Summary")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit")
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding()

                        HStack{
                            HStack(spacing:0){
                                Text("Rep: ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                Text("3")
                                    .foregroundColor(Color("Button1"))
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                            .padding()
                            .frame(maxHeight:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )

                            HStack(spacing:0){
                                Text("Set: ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                Text("3")
                                    .foregroundColor(Color("Button1"))
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                            .padding()
                            .frame(maxHeight:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            
                            HStack(spacing:0){
                                Text("Time: ")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                Text("30s")
                                    .foregroundColor(Color("Button1"))
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                            .padding()
                            .frame(maxHeight:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            
                            Button {
                            } label: {
                                Text("Button")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 17, weight: .semibold, design: .default))
                                    .padding(.horizontal)
                                
                            }
                            .frame( maxHeight: 35)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            
                        }
                        .padding(.vertical)
                        
                    }
                    .frame(maxWidth: 350, maxHeight: 212)
                    .background(Color("darkgreen"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .cornerRadius(14)
                    .padding(.bottom, 29)
                    
                    ForEach(exercises, id: \.name) { exercise in
                        VStack(spacing: 21){
                            VStack{
                                HStack{
                                    VStack(alignment: .leading, spacing: 5){
                                        Text(exercise.name)
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold, design: .default))
                                        Text(exercise.description)
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, design: .default))
                                            .padding(.bottom, 5)
                                        
                                        Button {
                                            routeManager.push(path : "preview")
                                        } label: {
                                            Text("Button")
                                                .foregroundStyle(Color.black)
                                                .font(.system(size: 17, weight: .semibold, design: .default))
                                                .padding(.horizontal)
                                            
                                        }
                                        .frame( maxHeight: 25)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(15)
                                        
                                    }
                                    Image(exercise.image)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                }
                                
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
                .padding(.horizontal, 20)

            }
            .ignoresSafeArea(.all)
            .navigationDestination(for : String.self){ path in
                AnyView(routeManager.getViewFromRoute(path: path))
            }

        }
      
    }
}

#Preview {
    HomeView()
}
