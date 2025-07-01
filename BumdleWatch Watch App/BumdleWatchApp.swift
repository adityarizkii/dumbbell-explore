//
//  BumdleWatchApp.swift
//  BumdleWatch Watch App
//
//  Created by Muhammad Chandra Ramadhan on 28/06/25.
//

import SwiftUI
import Foundation
import WatchConnectivity
import WatchKit

@main
struct BumdleWatch_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor(WatchSessionManager.self) var delegate
    @StateObject var runtimeManager = RuntimeManager()

    var body: some Scene {
        WindowGroup {
            ContentView(manager : delegate)
                .environmentObject(runtimeManager) 

        }
    }
}



