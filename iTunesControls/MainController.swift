//
//  MainController.swift
//  iTunesControls
//
//  Created by Nimrod Ben Simon on 7/8/18.
//  Copyright © 2018 nbs. All rights reserved.
//

import Cocoa
import iTunesLibrary
import ScriptingBridge

class MainController: NSObject {
    
    @IBOutlet weak var statusMenu: NSMenu!
    
    
    let nextStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let playPauseStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let previousStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var itunes: iTunesApplication?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
        setupItunesHandle()
        setCorrectPlayerState()
        //
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(handleNotification(notification:)), name: NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self, name: NSNotification.Name(rawValue: "com.apple.iTunes.playerInfo"), object: nil)
    }
    
    @objc func handleNotification(notification: Notification) {
        print(notification.userInfo)
        setCorrectPlayerState()
        //        let libraryPredicate = NSPredicate(format: "name == 'Library' && kind == %i", iTunesESrc.library.rawValue)
        //        let library = itunes?.sources?().filter(using: libraryPredicate)
    }

    
    // MARK:- Setup functions
    
    func setupButtons() {
        previousStatusItem.setImage(named: "previous")
        playPauseStatusItem.setImage(named: "play")
        nextStatusItem.setImage(named: "next")
        
        previousStatusItem.button?.action = #selector(handlePrevious)
        playPauseStatusItem.button?.action = #selector(handlePlayPause)
        nextStatusItem.button?.action = #selector(handleNext)
        
        previousStatusItem.button?.target = self
        playPauseStatusItem.button?.target = self
        nextStatusItem.button?.target = self
        
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
    
    @objc func handlePrevious(_ button: NSStatusBarButton) {
        itunes?.backTrack?()
    }
    
    @objc func handlePlayPause(_ button: NSStatusBarButton) {
        itunes?.playpause?()
    }
    
    @objc func handleNext(_ button: NSStatusBarButton) {
        itunes?.nextTrack?()
    }
    
    
}
