//
//  SpeechManager.swift
//  Bumdle
//
//  Created by Muhammad Chandra Ramadhan on 25/06/25.
//
import Foundation
import AVFoundation

final class SpeechManager {
    private let synthesizer = AVSpeechSynthesizer()

    /// Mengucapkan teks dengan bahasa tertentu. Default: `"en-US"`
    /// - Parameters:
    ///   - text: Kalimat yang akan diucapkan
    ///   - language: Kode bahasa (contoh: `"en-US"`, `"id-ID"`)
    func speak(_ text: String, language: String = "en-GB") {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("⚠️ Teks kosong. Tidak ada yang dibacakan.")
            return
        }

        let utterance = AVSpeechUtterance(string: text)

        // Coba cari voice berdasarkan kode bahasa
        if let voice = AVSpeechSynthesisVoice(language: language) {
            utterance.voice = voice
        } else {
            print("⚠️ Voice dengan bahasa '\(language)' tidak tersedia. Menggunakan voice default.")
        }

        // Pengaturan suara
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        synthesizer.speak(utterance)
    }

    /// Menghentikan ucapan langsung
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
   

    /// Mengecek apakah sedang berbicara
    func isSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }

    /// Menampilkan semua voice yang tersedia di perangkat
    func listAvailableVoices() {
        let voices = AVSpeechSynthesisVoice.speechVoices()

        print("🗣️ Voice yang tersedia di perangkat:")
        for voice in voices {
            print("• \(voice.language) - \(voice.name)")
        }
    }
}
