//
//  ColorDescriptionView.swift
//
//
//  Created by Daniel Capra on 01/11/2023.
//

import AppKit
import Foundation
import struct SwiftUI.Binding

internal class ColorDescriptionView: NSView {
    var textColor: Binding<NSColor>!
    var currentlySampledColor: Binding<NSColor?>!
    var colorDescription: Binding<String?>!
    var windowFrameWidthBinding: Binding<CGFloat?>!
    
    internal init(
        frame frameRect: NSRect,
        textColor: Binding<NSColor>,
        currentlySampledColor: Binding<NSColor?>,
        colorDescription: Binding<String?>,
        windowFrameWidthBinding: Binding<CGFloat?>!
    ) {
        self.textColor = textColor
        self.currentlySampledColor = currentlySampledColor
        self.colorDescription = colorDescription
        self.windowFrameWidthBinding = windowFrameWidthBinding
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var currentContext: CGContext? {
        NSGraphicsContext.current?.cgContext
    }
    
    override func draw(_: NSRect) {
        guard let context = currentContext else {
            // Weird ??
            fatalError()
        }
        
        // Clear the drawing rect
        context.clear(self.bounds)
        
        guard let sampleColor = currentlySampledColor.wrappedValue,
              let colorDescription = colorDescription.wrappedValue else {
            return
        }
        
        let rect = self.bounds
        // Clipping path
        let path = CGMutablePath()
        path.addRoundedRect(
            in: rect,
            cornerWidth: 8,
            cornerHeight: 8
        )
        context.addPath(path)
        context.clip()
        
        // Background
        context.addPath(path)
        context.setFillColor(sampleColor.cgColor)
        context.fillPath()
        
        // Stroke
        context.addPath(path)
        context.setStrokeColor(textColor.wrappedValue.cgColor)
        context.setLineWidth(2)
        context.strokePath()
        
        // Text
        let font = NSFont.systemFont(ofSize: 14)
        
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor.wrappedValue
        ]
        
        let myText = colorDescription
        let attributedString = NSAttributedString(string: myText, attributes: attributes)
        windowFrameWidthBinding.wrappedValue = attributedString.size().width + 32
        
        attributedString.draw(
            at: .init(
                x: rect.midX - attributedString.size().width / 2,
                y: rect.midY - attributedString.size().height / 2
            )
        )
    }
}
