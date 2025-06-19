//
//  ListViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 13/06/25.
//

import SwiftUI

class ListViewModel: ObservableObject {
    @Published var items: [Step] = [
        Step(title: "Step 1", description: "Description 1"),
        Step(title: "Step 2", description: "Description 2"),
        Step(title: "Step 3", description: "Description 3"),
    ]
    
    func ListView() -> some View {
        VStack(alignment: .leading) {
            ForEach(Array(self.items.enumerated()), id: \.1) { index, item in
                HStack(alignment: .top) {
                    VStack {
                        Text("\(index + 1)")
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                                
                            )
                        
                        
                        
                        if index != self.items.count - 1 {
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
                            
                            Text(self.items[index].description)
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
    }
    
    
}


#Preview{
    Preview()
}
