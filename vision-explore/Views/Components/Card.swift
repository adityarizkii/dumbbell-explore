//
//  Card.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 13/06/25.
//
import SwiftUI

struct Card: View {
    @Binding public var path : NavigationPath
    var geometry: GeometryProxy
    var title: String
    var description : String
    
    var body: some View {
        Group {
            VStack(spacing : 20){
                Text(title)
                    .font(.title.bold())
                    .padding()
                    .padding(.top, 30)
                
                Image(systemName: "photo")
                    .font(.system(size : 150))
                
                Text(description)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 20)
                
                Button(action : {
                    path.append("exercise")
                }){
                    Text("Mulai")
                        .frame(maxWidth : .infinity)
                        .padding()
                        .font(.headline.bold())
                        .foregroundStyle(.black)
                }
                .background(
                    RoundedRectangle(cornerRadius : 20)
                        .stroke(.black, lineWidth:  CGFloat(2))
                )
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 20)

        }
        .frame(width : CGFloat(geometry.size.width))
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.3))
                .padding(.horizontal, 25)
        )
        .padding(.vertical)
       
    }
}
