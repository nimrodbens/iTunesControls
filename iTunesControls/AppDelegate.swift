//
//  AppDelegate.swift
//  iTunesControls
//
//  Created by Nimrod Ben Simon on 7/8/18.
//  Copyright © 2018 nbs. All rights reserved.
//

import Cocoa
import iTunesLibrary
import ScriptingBridge

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var statusMenu: NSMenu!
    
    
    let nextStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let playPauseStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let previousStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var itunes: iTunesApplication?
    
    @IBAction func handleQuit(_ sender: NSMenuItem) {
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        setupButtons()
        setupItunesHandle()
        setCorrectPlayerState()
        //
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(handleNotification(notification:)), name: NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
        
    }
    
    @objc func handleNotification(notification: Notification) {
        print(notification.userInfo)
        setCorrectPlayerState()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        DistributedNotificationCenter.default().removeObserver(self, name: NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
    }
    
    // MARK:- Setup functions
    
    func setupButtons() {
        
        previousStatusItem.setImage(named: "previous")
        playPauseStatusItem.setImage(named: "play")
        nextStatusItem.setImage(named: "next")
        
        previousStatusItem.button?.action = #selector(handlePrevious)
        playPauseStatusItem.button?.action = #selector(handlePlayPause)
        nextStatusItem.button?.action = #selector(handleNext)
    }
    
    func setupItunesHandle() {
        guard let itunes: iTunesApplication = SBApplication.init(bundleIdentifier: "com.apple.itunes") else {
            print("error")
            return
        }
        self.itunes = itunes
    }
    
    func setCorrectPlayerState() {
        playPauseStatusItem.setImage(named: "play")
        if let playerState = itunes?.playerState {
            if playerState == .playing {
                playPauseStatusItem.setImage(named: "pause")
            }
        }
    }
    
    // MARK:- target actions
    
    @objc func handlePrevious() {
        itunes?.backTrack?()
    }
    
    @objc func handlePlayPause() {
        itunes?.playpause?()
    }
    
    @objc func handleNext() {
        itunes?.nextTrack?()
    }
}

extension NSStatusItem {
    func setImage(named name: String) {
        let image = NSImage.init(named: name)
        image?.isTemplate = true
        button?.image = image
    }
}
