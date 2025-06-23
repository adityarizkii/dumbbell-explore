//
//  HomeViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    var routeManager : RouteManager
    
    init(routeManager: RouteManager) {
        self.routeManager = routeManager
    }
    
    func showExerciseList() -> some View{
        ForEach(exercises, id: \.name) { exercise in
            VStack(spacing: 21){
                VStack{
                    HStack{
                        VStack(alignment: .leading, spacing: 5){
                            Text(exercise.name)
                                .foregroundColor(.white)
                                .font(.body)
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
                                        self.routeManager.push(path : "preview")
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
}
