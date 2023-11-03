//
//  Extensions.swift
//
//
//  Created by Daniel Capra on 02/11/2023.
//

import Foundation
import AppKit.NSColor

internal extension NSColor {
    func correctingColorspace(_ colorspace: NSColorSpace) -> NSColor {
        // need a pointer to a C-style array of CGFloat
        let compCount = self.numberOfComponents
        let comps = UnsafeMutablePointer<CGFloat>.allocate(capacity: compCount)
        self.getComponents(comps)
        return NSColor(colorSpace: colorspace, components: comps, count: compCount)
    }
}

internal extension CGImage {
    func colorAtCenter() -> NSColor? {
        let bitmapImageRep = NSBitmapImageRep(cgImage: self)
                
        let centerX = Int(bitmapImageRep.size.width) / 2
        let centerY = Int(bitmapImageRep.size.height) / 2
        
        let color = bitmapImageRep.colorAt(x: centerX, y: centerY)
        let correctedColor = color?.correctingColorspace(bitmapImageRep.colorSpace) ?? color
        return correctedColor
    }
}
