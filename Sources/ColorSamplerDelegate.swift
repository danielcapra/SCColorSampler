//
//  ColorSamplerDelegate.swift
//
//
//  Created by Daniel Capra on 29/10/2023.
//

import AppKit
import Foundation

internal protocol ColorSamplerDelegate: NSWindowDelegate {
    func callSelectionHandler(color: NSColor?)
    
    func callMouseMovedHandler(color: NSColor)
    
    var config: SCColorSamplerConfiguration { get }
}

extension ColorSampler: ColorSamplerDelegate {
    var config: SCColorSamplerConfiguration {
        guard let config = self.configuration else {
            return SCColorSamplerConfiguration()
        }
        return config
    }
    
    func callSelectionHandler(color: NSColor?) {
        self.selectionHandlerBlock?(color)
        self.reset()
    }
    
    func callMouseMovedHandler(color: NSColor) {
        self.onMouseMovedHandlerBlock?(color)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? ColorSamplerWindow,
              let unwrappedWindow = self.colorSamplerWindow,
              window == unwrappedWindow else { return }
        
        window.acceptsMouseMovedEvents = true
    }
    
    func windowDidResignKey(_ notification: Notification) {
        guard let window = notification.object as? ColorSamplerWindow,
              let unwrappedWindow = self.colorSamplerWindow,
              window == unwrappedWindow else { return }
        self.reset()
    }
}
