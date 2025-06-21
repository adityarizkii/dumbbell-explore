//
//  RectMask.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 15/06/25.
//
import SwiftUI
//
//struct Rectmask: View {
//    var body: some View {
//           GeometryReader { geo in
//               let size = geo.size
//               let circleSize: CGFloat = 200
//               
//               ZStack {
//                   // Seluruh area putih (tidak dilubangi)
//                   Color.white
//                   
//                   // Lubang (hitam → akan jadi transparan)
//                   RoundedRectangle(cornerRadius : 20)
//                       .padding(.horizontal, 20)
//                       .padding(.vertical, 50)
//                       .offset(y : 10)
//                       .frame(maxWidth : .infinity, maxHeight : geo.size.height * 0.8)
//                       .blendMode(.destinationOut) // Ini kuncinya!
//               }
//               .compositingGroup() // Diperlukan untuk blend mode bekerja
//           }
//       }
//}
//

struct Rectmask: View {
    var body: some View {
        GeometryReader { geo in
            let frameHeight = geo.size.height * 0.8
//            let frameHeight: CGFloat = 680
            let cornerRadius: CGFloat = 15

            ZStack {

                Color.white


                RoundedRectangle(cornerRadius: cornerRadius)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
                    .blendMode(.destinationOut)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .trim(from: 0.1, to: 0.4)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                            startPoint: .trailing,
                            endPoint: .leading
                            
                        ),
                        lineWidth: 4
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .trim(from: 0.6, to: 0.9)
                    .stroke(
                       LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 4
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 50)
                    .offset(y: 10)
                    .frame(maxWidth: .infinity, maxHeight: frameHeight)
            }
            .compositingGroup()
        }
        .ignoresSafeArea()
    }
}


#Preview{
    ContentView()
}
