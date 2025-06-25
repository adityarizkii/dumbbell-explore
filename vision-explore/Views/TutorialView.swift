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
    @EnvironmentObject var routeManager: RouteManager
    @EnvironmentObject var exerciseManager: ExerciseManager
    @State private var selectedSegment = 0
    
    var body: some View {
        @State var exercise = exerciseManager.exercise
        ScrollView {
            VStack(spacing: 20) {
                VideoSection()
                SegmentedSection(selectedSegment: $selectedSegment)
                SegmentedContent(selectedSegment: selectedSegment, exercise: exercise)
                // Button statis di bawah segmented
                Button(action: {
                    routeManager.push("firstguidance")
                }) {
                    Text("Start Exercise")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("Button1"),Color("Button2") ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#1a1a1a"))
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(hex: "#1a1a1a"), for: .navigationBar)
    }
}

struct VideoSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let bundleVideoURL = Bundle.main.url(forResource: "sample_video", withExtension: "mp4") {
                VideoPlayer(player: AVPlayer(url: bundleVideoURL))
                    .frame(height: 200)
                    .cornerRadius(12)
            } else {
                Text("Local video not found")
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
            }
        }
        .padding()
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
    let exercise: Exercise
    @ViewBuilder
    var body: some View {
        if selectedSegment == 0 {
            AboutContent(exercise: exercise)
        } else {
            KeyMomentContent(exercise: exercise)
        }
    }
}

struct AboutContent: View {
    let exercise: Exercise
    var body: some View {
        VStack(spacing: 15) {
            Text(exercise.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Badge horizontal
            HStack(spacing: 10) {
                BadgeView(text: "8 repetisi")
                ForEach(exercise.muscles, id: \ .self) { muscle in
                    BadgeView(text: muscle)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(exercise.detail.about)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .cornerRadius(12)
        }
        .padding(24)
    }
}

struct KeyMomentContent: View {
    let exercise: Exercise
    var body: some View {
        VStack(spacing: 12) {
            ForEach(exercise.detail.key_moment, id: \ .self) { moment in
                KeyMomentCard(
                    title: "Image",
                    description: moment.key_description
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
    let title: String // key_image
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64, height: 64)
                .cornerRadius(10)
                .background(Color.gray.opacity(0.2))
            VStack(alignment: .leading, spacing: 8) {
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
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

//#Preview {
//    NavigationStack {
//        Tuto()
//    }
//}
