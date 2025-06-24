//
//  PreviewViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 23/06/25.
//

import SwiftUI

class TutorialViewModel: ObservableObject {
    @Published  var items: [Step]
    
    init() {
        self.items  = [
            Step(title: "Step 1", description: "Description 1"),
            Step(title: "Step 2", description: "Description 2"),
            Step(title: "Step 3", description: "Description 3"),
        ]
    }
    
    func getStep() -> [Step]{
        return self.items
    }
    
   
}
