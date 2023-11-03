//
//  ColorSampler.swift
//  
//
//  Created by Daniel Capra on 29/10/2023.
//

import AppKit
import Combine
import Foundation
import ScreenCaptureKit
import struct SwiftUI.Binding

internal class ColorSampler: NSObject {
    // Properties
    static let shared = ColorSampler()
    
    var colorSamplerWindow: ColorSamplerWindow?
    var configuration: SCColorSamplerConfiguration?
    
    var onMouseMovedHandlerBlock: ((NSColor) -> Void)?
    var selectionHandlerBlock: ((NSColor?) -> Void)?
    
    // Functions
    func sample(
        onMouseMoved: @escaping (NSColor) -> Void,
        selectionHandler: @escaping (NSColor?) -> Void,
        configuration: SCColorSamplerConfiguration
    ) {
        self.reset()
        self.onMouseMovedHandlerBlock = onMouseMoved
        self.selectionHandlerBlock = selectionHandler
        self.configuration = configuration
        self.show()
    }
    
    private func show() {
        // Should never happen
        guard let configuration = configuration else {
            return
        }
        
        var windowInit: (
            contentRect: NSRect,
            styleMask: NSWindow.StyleMask,
            backing: NSWindow.BackingStoreType,
            defer: Bool
        ) {
            return (
                NSRect.init(origin: .zero, size: configuration.loupeSize.getSize()),
                NSWindow.StyleMask.borderless,
                NSWindow.BackingStoreType.buffered,
                true
            )
        }
        
        self.colorSamplerWindow = ColorSamplerWindow.init(
            contentRect: windowInit.contentRect,
            styleMask: windowInit.styleMask,
            backing: windowInit.backing,
            defer: windowInit.defer,
            delegate: self
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKey(_:)),
            name: NSWindow.didBecomeKeyNotification,
            object: self.colorSamplerWindow
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidResignKey(_:)),
            name: NSWindow.didResignKeyNotification,
            object: self.colorSamplerWindow
        )
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        self.colorSamplerWindow?.makeKeyAndOrderFront(self)
        self.colorSamplerWindow?.orderedIndex = 0
        
        // prepare image for window's contentView in advance
        self.colorSamplerWindow?.mouseMoved(with: NSEvent())
        
        NSCursor.hide()
    }
    
    func reset() {
        NSCursor.unhide()
        NotificationCenter.default.removeObserver(self)
        if let window = self.colorSamplerWindow {
            window.stopStream()
            window.childWindows?.forEach({ $0.close() })
            window.close()
        }
        self.configuration = nil
        self.colorSamplerWindow = nil
        self.onMouseMovedHandlerBlock = nil
        self.selectionHandlerBlock = nil
    }
}
