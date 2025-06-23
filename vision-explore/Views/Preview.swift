//
//  Boarding.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 12/06/25.
//

import SwiftUI

struct Preview: View {
    @EnvironmentObject var routeManager:RouteManager
    
    var body: some View {
        @State var previewViewModel:PreviewViewModel = PreviewViewModel()

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
                    
                    previewViewModel.render()
                        .frame(maxWidth: .infinity, alignment : .leading)

                    
                    Text("Seated bicep curls are a strength-training  exercise that targets your biceps, the muscles  in the front part of your upper arms. By sitting  down while doing this movement, your body stays more stable, minimizing the involvement of other muscles and allowing for better isolation of the biceps. ")
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth : .infinity, alignment : .leading)
                        .padding(.bottom , 10)
                    
                    previewViewModel.ListView()

                    Button(
                        action : {
                            routeManager.push(path : "firstguidance")
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


#Preview{
    HomeView()
        .environmentObject(RouteManager())
}
