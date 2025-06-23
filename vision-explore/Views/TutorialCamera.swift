//
//  TutorialCamera.swift
//  vision-explore
//
//  Created by M Ikhsan Azis Pane on 22/06/25.
//
import SwiftUI

struct TutorialCamera: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var routeManager: RouteManager
    @State private var currentPage = 0
    private let totalPages = 3

    var body: some View {
            VStack(spacing: 24) {
                ZStack{
                    VStack{
                        Spacer()
                        
                        Image(pageImage(for: currentPage))
                            .resizable()
                            .frame(width: 301, height: 550)
                            .padding(.bottom, 24)

                    }
                    .frame(maxHeight: .infinity)
                    .ignoresSafeArea()

                    VStack{
                        
                        PageIndicator(currentPage: currentPage, totalPages: totalPages)

                        VStack(spacing: 12) {
                            Text(pageTitle(for: currentPage))
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            Text(pageSubtitle(for: currentPage))
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(.top, 20)
                        


                        Spacer()

                        Button(action: {
                            withAnimation {
                                if currentPage < totalPages - 1 {
                                    currentPage += 1
                                } else {
                                    routeManager.push(path : "workout")
                                    print("Start real-time guiding")
                                }
                            }
                        }) {
                            Text(buttonText(for: currentPage))
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .cornerRadius(10)
                                .padding(.horizontal, 40)
                        }
                        .padding(.bottom, 40)
                    }
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.darkBg.edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
                Text("Back")
                    .foregroundColor(.white)
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tutorial Camera")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }

        }
            
    // MARK: - Content Helpers
    func buttonText(for page: Int) -> String {
        switch page {
        case 0: return "Got it"
        case 1: return "Let’s Move"
        case 2: return "Let’s Start Real Time Guiding"
        default: return "Next"
        }
    }

    func pageTitle(for page: Int) -> String {
        switch page {
        case 0: return "Set your camera distance"
        case 1: return "Guided movement"
        case 2: return "Match your movement"
        default: return ""
        }
    }

    func pageSubtitle(for page: Int) -> String {
        switch page {
        case 0: return "Turn to the side and make sure your full arm is clearly visible on camera."
        case 1: return "Follow the guided movement and Keep the posture line green as you move."
        case 2: return "Follow tempo the circle. Lift and lower the dumbbell in sync with the rhythm."
        default: return ""
        }
    }
    
    func pageImage(for page: Int) -> String {
        switch page {
        case 0 : return "iphone"
        case 1 : return "iphone2"
        case 2 : return "iphone3"
        default: return ""
        }
    }
}

// MARK: - Page Indicator Component
struct PageIndicator: View {
    var currentPage: Int
    var totalPages: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                if index == currentPage {
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: 16, height: 6)
                        .transition(.scale)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 6, height: 6)
                        .transition(.scale)
                }
            }
        }
    }
}

#Preview {
    TutorialCamera()
        .environmentObject(RouteManager())
}
