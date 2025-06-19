//
//  Boarding.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 12/06/25.
//

import SwiftUI

struct Preview: View {

    var body: some View {
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
                
                
                HStack{
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
                .frame(maxWidth: .infinity, alignment : .leading)
                
                Button(
                    action : {
                                    
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
                
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .frame(maxWidth : .infinity, alignment : .leading)
                
                
                ListViewModel().ListView()
                
               
            
            }
            .preferredColorScheme(.dark)
            .padding(.horizontal, 20)
        }
       
    }
}


#Preview{
    Preview()
}
