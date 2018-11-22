//
//  SpeechHelper.swift
//  HelixBrain
//
//  Created by Emmanuel  Ogbewe on 11/22/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import AudioUnit

public class SpeechHelper{
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()
    
    private var speechRequest : SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask : SFSpeechRecognitionTask?
    
    private let audioSession = AVAudioSession.sharedInstance()
    
    public func startReading(text: String, delegate : AVSpeechSynthesizerDelegate){
        speechRequest?.endAudio()
        audioEngine.stop()
        do {
            try self.audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try self.audioSession.setMode(AVAudioSession.Mode.default)
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try self.audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            // handle errors
            print(error.localizedDescription)
        }
        
        let speechUtterance = AVSpeechUtterance(string: text)
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = delegate
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-gb")
        speechUtterance.rate = 0.5
        speechUtterance.volume = 1.0
        speechUtterance.pitchMultiplier = 1.0
        synthesizer.speak(speechUtterance)
    }
}

