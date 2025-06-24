//
//  TestAnimation.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 24/06/25.
//
import SwiftUI

struct TestAnimation: View {
    @State private var isVisible = false
    @State private var showSecondText = false
    @State private var showThirdText = false
    
    var body: some View {
        VStack {
            if !isVisible {
                Text("Tap to Toggle View")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            isVisible.toggle() // Toggle visibility of the first text
                        }
                    }
            } else if showSecondText {
                Text("This text will appear for 3 seconds")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .transition(.opacity) // Apply opacity transition
                    .onAppear {
                        // After 3 seconds, show third view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showSecondText = false
                                showThirdText = true
                            }
                        }
                    }
            } else if showThirdText {
                Text("This is the third view!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                    .transition(.opacity) // Apply opacity transition
            }
        }
        .onAppear {
            // Start showing second text after the first view disappears
//            if isVisible && !showSecondText {
//                withAnimation {
//                    showSecondText = true
//                }
            }
        }
    }
//}


#Preview {
    TestAnimation()
}
