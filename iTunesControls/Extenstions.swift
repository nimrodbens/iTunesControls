//
//  Extenstions.swift
//  iTunesControls
//
//  Created by Nimrod Ben Simon on 7/8/18.
//  Copyright © 2018 nbs. All rights reserved.
//

import Cocoa

extension NSStatusItem {
    func setImage(named name: String) {
        let image = NSImage.init(named: name)
        image?.isTemplate = true
        button?.image = image
    }
}
