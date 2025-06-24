//
//  Boarding.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 12/06/25.
//

import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var routeManager:RouteManager
    
    var body: some View {
        @State var tutorialView = TutorialViewModel()

        ScrollView{
            GeometryReader{ geometry in
                VStack{
                    Text("Video Demo")
                        .font(.title.bold())
                    Image("Image")
                        .frame(maxWidth : .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius : 20)
                                .fill(.black.opacity(0.2))
                        )

                    Text("Bicep Curl")
                        .font(.title.bold())
                        .frame(maxWidth : .infinity, alignment : .leading)
                    
                    HStack(){
                        ForEach(0..<2){ _ in
                            Button(action : {
                                
                            }){
                                Text("Start Demo")
                                    .foregroundStyle(.white)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.gray.opacity(0.8))
                                    )
                            }
                            
                        }
                       
                    }
                    .frame(maxWidth : .infinity, alignment : .leading)

                    
                    Text("Seated bicep curls are a strength-training  exercise that targets your biceps, the muscles  in the front part of your upper arms. By sitting  down while doing this movement, your body stays more stable, minimizing the involvement of other muscles and allowing for better isolation of the biceps. ")
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth : .infinity, alignment : .leading)
                        .padding(.bottom , 10)
                    
                    VStack(alignment: .leading) {
                        ForEach(Array(tutorialView.items.enumerated()), id: \.1) { index, item in
                            HStack(alignment: .top) {
                                VStack {
                                    Text("\(index + 1)")
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .fill(Color.blue)
                                            
                                        )
                                    
                                    
                                    
                                    if index != tutorialView.items.count - 1 {
                                        Rectangle()
                                            .fill(Color.blue)
                                            .frame(width: 2, height: 30)
                                    }
                                }
                                .padding(.top, 4)
                                .offset(y : 15)
                                
                                HStack() {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 70, height: 50)
                                        .foregroundColor(.blue)
                                    VStack{
            //                            Text(self.items[index].title)
            //                                .font(.headline)
            //                                .frame(maxWidth : .infinity, alignment : .leading)
                                        
                                        Text(tutorialView.items[index].description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .frame(maxWidth : .infinity, alignment : .leading)
                                    }
                                  

                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius : 10)
                                        .fill(.gray.opacity(0.2))
                                )
                                .padding(.leading, 8)
                            }
                        }
                    }

                    Button(
                        action : {
                            routeManager.push("firstguidance")
                        }){
                            Text("Start Exercise")
                                .foregroundStyle(.black)
                                .font(.headline.bold())
                                .frame(maxWidth : .infinity)
                                .padding(20)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(15)
                    }
                        .padding(.vertical, 20)
                
                }
                .preferredColorScheme(.dark)
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth : .infinity, maxHeight : .infinity)
    }
}



