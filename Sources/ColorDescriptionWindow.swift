//
//  ColorDescriptionWindow.swift
//
//
//  Created by Daniel Capra on 01/11/2023.
//

import AppKit
import Foundation
import struct SwiftUI.Binding

internal class ColorDescriptionWindow: NSWindow {
    // Init
    internal override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(contentRect: contentRect,
                   styleMask: style,
                   backing: backingStoreType,
                   defer: flag)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .popUpMenu
    }
}
