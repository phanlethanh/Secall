//
//  RingTone.swift
//  PJsua_Swift
//
//  Created by Phan Le Thanh on 5/11/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import AVFoundation

class Ringtone {
    
    let file = "apple_ring"
    let fileExtension = "mp3"
    var player : AVAudioPlayer! = nil // will be Optional, must supply initializer
    
    // Singleton for only one instance
    class var sharedInstance: Ringtone {
        struct Static {
            static let instance = Ringtone()
        }
        return Static.instance
    }

    func startRinging() {
        let path = NSBundle.mainBundle().pathForResource(Utility.INCOMING_CALL_RING, ofType:fileExtension)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.numberOfLoops = 20
        player.play()
    }
    
    func stopRinging() {
        if player != nil {
            player.stop()
        }
    }
    
    func startRingingInc(){
        let path = NSBundle.mainBundle().pathForResource(Utility.CALLING_RING, ofType:fileExtension)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.numberOfLoops = 20
        player.play()
    }
    
    func startSoundBusy(){
        let path = NSBundle.mainBundle().pathForResource(Utility.CALLING_RING, ofType:fileExtension)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.numberOfLoops = 20
        player.play()
    }

    func startSoundStartCall(){
        let path = NSBundle.mainBundle().pathForResource(Utility.START_CALL_RING, ofType:fileExtension)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
    }
    
    func startSoundEndCall(){
        let path = NSBundle.mainBundle().pathForResource(Utility.END_CALL_RING, ofType:fileExtension)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
    }
    
    func startSoundOfNumber(number:Int){
        let path = NSBundle.mainBundle().pathForResource(Utility.generateSound(number), ofType:fileExtension)
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
    }
    
    // Enable loud speaker
    func setAudioToLoudSpeaker() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error:&error) {
            println("could not set output to speaker")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
    
    // Enable ear speaker
    func setAudioToEarSpeaker() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.None, error:&error) {
            println("could not set output to speaker")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }


}
