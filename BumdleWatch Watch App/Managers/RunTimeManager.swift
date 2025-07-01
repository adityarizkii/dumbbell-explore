//
//  RunTimeManager.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 01/07/25.
//

import WatchKit

class RuntimeManager: NSObject, ObservableObject, WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: (any Error)?) {
    }
    
    var session: WKExtendedRuntimeSession?

    func startSession() {
        session = WKExtendedRuntimeSession()
        session?.delegate = self
        session?.start()
    }

    func stopSession() {
        session?.invalidate()
    }

    func extendedRuntimeSessionDidStart(_ session: WKExtendedRuntimeSession) {
        print("✅ Extended runtime session started")
    }

    func extendedRuntimeSessionWillExpire(_ session: WKExtendedRuntimeSession) {
        print("⚠️ Extended runtime session will expire soon")
    }

    func extendedRuntimeSessionDidInvalidate(_ session: WKExtendedRuntimeSession) {
        print("❌ Extended runtime session ended")
    }
}
