//
//  TrialViewModel.swift
//  vision-explore
//
//  Created by Muhammad Chandra Ramadhan on 25/06/25.
//

import Foundation

class TrialViewModel : ObservableObject{
    @Published var step : Int
    @Published var maxStep : Int
    @Published var isMuted : Bool = false
    @Published var trialGuidance : [TrialGuidance]
    let speechManager : SpeechManager
    
    
    init(  trialGuidance : [TrialGuidance]? = []) {
        self.step = 0
        self.trialGuidance = trialGuidance ?? []
        self.maxStep = (trialGuidance ?? []).count
        self.speechManager = SpeechManager()
    }
    
    func updateGuidance(_ trialGuidance : [TrialGuidance]){
        self.trialGuidance = trialGuidance
        self.maxStep = (trialGuidance).count
    }
    
    func playSound(){
        
        if !self.speechManager.isSpeaking() && isMuted == false {
            self.speechManager.speak(self.getCurrentGuidance()?.description ?? "Great Job, Lets start your first exercise")
        }
    }
    
    func getCurrentGuidance() -> TrialGuidance? {
        if self.step >= self.trialGuidance.count {
            return nil
        }
        return self.trialGuidance[self.step]
    }
    
    func getTotalGuidance() -> Int {
        return self.trialGuidance.count
    }
    
}
