//
//  RectMask.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 15/06/25.
//
import SwiftUI

struct Rectmask: View {
    var body: some View {
           GeometryReader { geo in
               let size = geo.size
               let circleSize: CGFloat = 200
               
               ZStack {
                   // Seluruh area putih (tidak dilubangi)
                   Color.white
                   
                   // Lubang (hitam → akan jadi transparan)
                   RoundedRectangle(cornerRadius : 20)
                       .padding(.horizontal, 20)
                       .padding(.vertical, 50)
                       .offset(y : 10)
                       .frame(maxWidth : .infinity, maxHeight : geo.size.height * 0.8)
                       .blendMode(.destinationOut) // Ini kuncinya!
               }
               .compositingGroup() // Diperlukan untuk blend mode bekerja
           }
       }
}


#Preview{
    ContentView()
}
