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
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 14, height: 14)
                        
                        if index != self.items.count - 1 {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 2, height: 50)
                        }
                    }
                    .padding(.top, 4)
                    .offset(y : 25)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(self.items[index].title)
                            .font(.headline)
                        Text(self.items[index].description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth : .infinity, alignment : .leading)

                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius : 10)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.leading, 8)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
    }
    
    
}


#Preview{
    Boarding()
}
