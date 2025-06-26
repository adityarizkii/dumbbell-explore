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
            VStack(spacing: 10) {
                VideoSection()
                SegmentedSection(selectedSegment: $selectedSegment)
                    .frame(maxWidth : .infinity)
                ScrollView {
                    SegmentedContent(selectedSegment: selectedSegment, exercise: exercise)
                }
               
                // Button statis di bawah segmented
                Spacer()
                
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
    @EnvironmentObject var exerciseManager: ExerciseManager
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let bundleVideoURL = Bundle.main.url(forResource: exerciseManager.exercise.image, withExtension: "mp4") {
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
                Text("About")
                    .font(.title)
                    .tag(0)
                    
                Text("Key Moment")
                    .font(.title)
                    .tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .colorScheme(.dark)
            .frame(maxWidth : .infinity)
        }
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
    var idx = 1
    var body: some View {
        ZStack{
            HStack{
                Rectangle()
                    .fill(.black)
                    .frame(width : 10)
                    .padding(.leading , 26)
                    .padding(.vertical, 50)

                Spacer()
            }
        
            
            VStack(spacing: 12) {
                ForEach(Array(exercise.detail.key_moment.enumerated()), id: \.offset) { index, moment in
                    KeyMomentCard(
                        title: moment.key_image,
                        description: moment.key_description,
                        idx: index+1
                    )
                }

            }
            .padding()
        }
        .frame(alignment : .leading)
        
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
    let idx: Int
    
    var body: some View {
        HStack{
            Text("\(idx)")
                .foregroundStyle(.white)
                .background(
                    Circle()
                        .fill(.black)
                        .frame(width: 30, height: 30)
                )
                .padding(.horizontal, 10)
            
            HStack(alignment: .center, spacing: 16) {
                    
                Image(title)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 102, height: 64)
                    .cornerRadius(10)
                VStack(alignment: .leading, spacing: 8) {
                    Text(description)
                        .font(.subheadline)
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
    NavigationStack {
        TutorialView()
            .environmentObject(RouteManager())
            .environmentObject(ExerciseManager())
    }
}
