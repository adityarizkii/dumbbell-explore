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
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .frame(maxWidth : .infinity, alignment : .leading)
                
                HStack{
                    ForEach(0..<2){ _ in
                        Button(action : {
                            
                        }){
                            Text("Start Demo")
                                .foregroundStyle(.white)
                                .font(.caption)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.gray)
                                )
                        }
                    }
                   
                }
                .frame(maxWidth: .infinity, alignment : .leading)
                
                ListViewModel().ListView()
                
                Button(action : {
                    
                }){
                    Text("Continue")
                        .foregroundStyle(.white)
                        .frame(maxWidth : .infinity)
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius : 20)
                                .fill()
                        )
                }
            
            }
            .padding(.horizontal, 20)
        }
       
    }
}


#Preview{
    Preview()
}
