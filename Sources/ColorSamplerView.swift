//
//  ColorSamplerView.swift
//
//
//  Created by Daniel Capra on 29/10/2023.
//

import AppKit
import Foundation
import struct SwiftUI.Binding

internal class ColorSamplerView: NSView {
    var zoom: Binding<SCColorSamplerConfiguration.ZoomValue?>!
    var image: Binding<CGImage?>!
    var loupeColor: Binding<NSColor>!
    
    var quality: SCColorSamplerConfiguration.Quality!
    var shape: SCColorSamplerConfiguration.LoupeShape!
    
    init(
        frame frameRect: NSRect,
        zoom: Binding<SCColorSamplerConfiguration.ZoomValue?>,
        image: Binding<CGImage?>,
        loupeColor: Binding<NSColor>,
        shape: SCColorSamplerConfiguration.LoupeShape,
        quality: SCColorSamplerConfiguration.Quality
    ) {
        self.zoom = zoom
        self.image = image
        self.quality = quality
        self.loupeColor = loupeColor
        self.shape = shape
        super.init(
            frame: frameRect
        )
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
        
        // Clear the drawing rect.
        context.clear(self.bounds)
        
        let rect = self.bounds
        
        let width: CGFloat = rect.width
        let height: CGFloat = rect.height
        
        // mask
        let path = shape.path(in: rect)
        context.addPath(path)
        context.clip()
        
        guard let image = self.image.wrappedValue,
              let zoom = self.zoom.wrappedValue else {
            return
        }
        
        // draw image
        context.setRenderingIntent(.relativeColorimetric)
        context.interpolationQuality = .none
        context.draw(image, in: rect)
        
        // Get dimensions
        let apertureSize: CGFloat = zoom.getApertureSize()
        
        let x: CGFloat = (width / 2.0) - (apertureSize / 2.0)
        let y: CGFloat = (height / 2.0) - (apertureSize / 2.0)
        
        // Square pattern
        let replicatorLayer = CAReplicatorLayer()
        
        let square = CALayer()
        let squareSize = zoom.getSquarePatternSize()
        let squareDisplacement = zoom.getSquarePatternDisplacement()
        square.borderWidth = 0.5
        square.borderColor = .black.copy(alpha: 0.15)
        square.frame = CGRect(x: x - (squareSize * 25),
                              y: y - (squareSize * 25),
                              width: squareSize,
                              height: squareSize)
        
        let instanceCount = 50
        
        replicatorLayer.instanceCount = instanceCount
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(squareSize, squareDisplacement, 0)
        
        replicatorLayer.addSublayer(square)
        
        let outerReplicatorLayer = CAReplicatorLayer()
        
        outerReplicatorLayer.addSublayer(replicatorLayer)
        
        outerReplicatorLayer.instanceCount = instanceCount
        outerReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(squareDisplacement, squareSize, 0)
        
        outerReplicatorLayer.render(in: context)
        
        // Draw inner rectangle
        let apertureRect = CGRect(x: x, y: y, width: apertureSize, height: apertureSize)
        context.setLineWidth(zoom.getApertureLineWidth())
        context.setStrokeColor(loupeColor.wrappedValue.cgColor)
        context.setShouldAntialias(false)
        context.stroke(apertureRect.insetBy(dx: zoom.getInsetAmount(), dy: zoom.getInsetAmount()))
        
        // Stroke outer rectangle
        context.setShouldAntialias(true)
        context.setLineWidth(4.0)
        context.setStrokeColor(loupeColor.wrappedValue.cgColor)
        context.addPath(path)
        context.strokePath()
    }
}
