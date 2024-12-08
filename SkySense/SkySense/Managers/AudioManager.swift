//
//  AudioManager.swift
//  SkySense
//
//  Created by Jan Stusio on 07/12/2024.
//

import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
 
    private var audioPlayers: [CelestialBody: (AVAudioPlayer?, AVAudioPlayer?)] = [:]
 
    init() {
        for body in CelestialBody.allCases {
            preloadAudioPlayers(for: body)
            print("Loaded audio players for \(body.rawValue)")
        }
    }
    
    private func preloadAudioPlayers(for body: CelestialBody) {
        
        guard let initialURL = Bundle.main.url(forResource: body.rawValue + "1", withExtension: "mp3"), let followupURL = Bundle.main.url(forResource: body.rawValue + "2", withExtension: "mp3") else {
            print("Could not form valid URLs for audio files.")
            return
        }
        do {
            let initialPlayer = try AVAudioPlayer(contentsOf: initialURL)
            let followupPlayer = try AVAudioPlayer(contentsOf: followupURL)
            audioPlayers[body] = (initialPlayer, followupPlayer)
        } catch {
            print("Could not create audio players for \(body.rawValue): \(error)")
        }
        
    }
    
    func stopAllPlayers() {
        for body in CelestialBody.allCases {
            if let initialPlayer = audioPlayers[body]?.0 {
                if initialPlayer.isPlaying {  // Check if playing to avoid errors
                    initialPlayer.stop()
                }
            }
             if let followupPlayer = audioPlayers[body]?.1 {
                if followupPlayer.isPlaying {  // Check if playing to avoid errors
                    followupPlayer.stop()
                }
            }
        }
    }
 
    func playInitial(body: CelestialBody) {
        stopAllPlayers()
        if let initialPlayer = audioPlayers[body]?.0 {
            initialPlayer.prepareToPlay()
            initialPlayer.play()
            print("Played initial sound for \(body.rawValue)")
        } else {
            print("Could not play initial sound for \(body.rawValue)")
        }
    }
 
    func playFollowup(body: CelestialBody) {
        stopAllPlayers()
        if let followupPlayer = audioPlayers[body]?.1 {
            followupPlayer.prepareToPlay()
            followupPlayer.play()
            print("Played followup sound for \(body.rawValue)")
        } else {
            print("Could not play followup sound for \(body.rawValue)")
        }
    }
}
