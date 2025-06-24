//
//  Boarding.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 12/06/25.
//

import SwiftUI
import AVKit

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct TutorialView: View {
    @State private var selectedSegment = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VideoPlayerView()
                SegmentedSection(selectedSegment: $selectedSegment)
                SegmentedContent(selectedSegment: selectedSegment)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#1a1a1a"))
        .navigationTitle("BicepCurl")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: "#1a1a1a"), for: .navigationBar)
    }
}

struct SegmentedSection: View {
    @Binding var selectedSegment: Int
    var body: some View {
        VStack {
            Picker("Select View", selection: $selectedSegment) {
                Text("About").tag(0)
                Text("Key Moment").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorScheme(.dark)
        }
        .padding(.horizontal)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

struct SegmentedContent: View {
    let selectedSegment: Int
    @ViewBuilder
    var body: some View {
        if selectedSegment == 0 {
            AboutContent()
        } else {
            KeyMomentContent()
        }
    }
}

struct AboutContent: View {
    @EnvironmentObject var routeManager : RouteManager

    var body: some View {
        VStack(spacing: 15) {
            Text("Seated Bicep Curl")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Badge horizontal
            HStack(spacing: 10) {
                BadgeView(text: "8 repetisi")
                BadgeView(text: "Biceps")
                BadgeView(text: "Under Arm")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("BicepCurl is a comprehensive fitness app designed to help you perfect your bicep curl form using advanced computer vision technology. The app provides real-time feedback and guidance to ensure you perform each rep with proper technique.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
            
            // Button pengganti fitur
            Button(action: {
                routeManager.push("firstguidance")
            }) {
                Text("Start Exercise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#333333"))
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

struct KeyMomentContent: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Key Moments in Bicep Curl")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                KeyMomentCard(
                    title: "Moment 1: Starting Position",
                    description: "Stand with feet shoulder-width apart, holding dumbbells at your sides with palms facing forward."
                )
                KeyMomentCard(
                    title: "Moment 2: Curl Up",
                    description: "Slowly curl the dumbbells up toward your shoulders, keeping your elbows close to your body."
                )
                KeyMomentCard(
                    title: "Moment 3: Peak Contraction",
                    description: "Hold the position briefly at the top, squeezing your biceps for maximum contraction."
                )
                KeyMomentCard(
                    title: "Moment 4: Controlled Descent",
                    description: "Slowly lower the dumbbells back to the starting position with controlled movement."
                )
            }
        }
        .padding()
    }
}

// Helper Views
struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

struct KeyMomentCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
    }
}

// BadgeView
struct BadgeView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color(hex: "#333333"))
            .clipShape(Capsule())
    }
}




#Preview {
    TutorialView()
        .environmentObject(RouteManager())
}
