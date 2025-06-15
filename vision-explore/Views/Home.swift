//
//  Home.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 11/06/25.
//

import SwiftUI



struct Home: View {
    @State private var selectedTab = 0
    @State var path : NavigationPath

    var body: some View {
        NavigationStack(path : $path){
            TabView(selection : $selectedTab){
                Tab("Exercise", systemImage: "dumbbell", value : 0) {
                    GeometryReader { geometry in
                        VStack{
                            Spacer()
                            Text("Choose your exercise")
                                .font(.largeTitle.bold())
                                .padding()
                            
                            ScrollView(.horizontal) {
                                HStack{
                                    ForEach(exercises, id: \.self){ exercise in
                                        Card(
                                            path : $path,
                                            geometry: geometry,
                                            title : exercise.name,
                                            description : exercise.description
                                        )

                                    }
                                }
                    
                            }
                            .scrollIndicators(.hidden)
                            Spacer()
                        }
                        
                    }
                    .frame(maxWidth : .infinity)
                }
                
                Tab("History", systemImage: "clock", value : 1){
                    
                }
                
            }
            .navigationDestination(for: String.self){ route in
                if route == "exercise"{
                    Boarding()
                }
            }
        }
    
        
    }
}

#Preview {
    Home(path : NavigationPath())
}
