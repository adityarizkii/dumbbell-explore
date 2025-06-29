//
//  WatchSessionManager.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 28/06/25.
//

import Foundation
import WatchConnectivity
import WatchKit

struct ExerciseDetail {
    var exercise: String
    var repetitions: Int
    var feedback: String

    static let empty = ExerciseDetail(exercise: "", repetitions: 0, feedback: "")
}


class WatchSessionManager: NSObject, WKExtensionDelegate, WCSessionDelegate, ObservableObject {
    @Published var text: String = "Welcome to Bumbdle"
    @Published var exerciseDetail: ExerciseDetail = ExerciseDetail(exercise : "", repetitions: 0, feedback: "Great")
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func applicationDidFinishLaunching() {
        // Optional, kalau mau setup lain
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let command = message["command"] as? String, command == "success" {
            WKInterfaceDevice.current().play(.success)
        }

        if let command = message["command"] as? String, command == "fail" {
            WKInterfaceDevice.current().play(.failure)
        }

        if let text = message["text"] as? String {
            print(text)

            DispatchQueue.main.async {
                self.text = text
            }
        }
        
        if let feedback = message["feeedback"] as? String {
            print(feedback)

            DispatchQueue.main.async {
                self.exerciseDetail = ExerciseDetail(exercise : self.exerciseDetail.exercise, repetitions: self.exerciseDetail.repetitions, feedback: feedback)
            }
        }
        
        if let rep = message["repetition"] as? String {
            print(rep)

            DispatchQueue.main.async {
                self.exerciseDetail = ExerciseDetail(exercise : self.exerciseDetail.exercise, repetitions: Int(rep)!, feedback: self.exerciseDetail.feedback)
            }
        }
        
        if let exercise = message["exercise"] as? String {
            print("Exercise : \(exercise)")
            DispatchQueue.main.async {
                self.exerciseDetail = ExerciseDetail(exercise : exercise, repetitions: self.exerciseDetail.repetitions, feedback: self.exerciseDetail.feedback)
            }
        }
    }

    // HARUS ADA ini biar delegate valid:
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession activated: \(activationState)")
    }
}
