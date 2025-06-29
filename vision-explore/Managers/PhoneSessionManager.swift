//
//  PhoneSessionManager.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 28/06/25.
//

import Foundation
import WatchConnectivity

class PhoneSessionManager: NSObject, WCSessionDelegate , ObservableObject{
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
 
    
    static let shared = PhoneSessionManager()

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("Supported")
        }else{
            print("Not Supported")
        }

    }

    // Kirim perintah vibrasi
    func sendVibrationCommand(_ type : String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["command": type], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error)")
            })
        } else {
            print("Watch is not reachable")
        }
    }

    func sendMessage(_ type : String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["text": type], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error)")
            })
        } else {
            print("Watch is not reachable")
        }
    }
    
    func sendData(_ key : String, _ value : String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage([key: value], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error)")
            })
        } else {
            print("Watch is not reachable")
        }
    }
    
    // Delegate wajib, bisa kosong
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    
    
}
