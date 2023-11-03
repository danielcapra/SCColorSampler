//
//  SCColorSamplerConfiguration.swift
//
//
//  Created by Daniel Capra on 29/10/2023.
//

import class AppKit.NSColor
import class AppKit.CGPath
import class AppKit.CGMutablePath
import Foundation

///
/// SCColorSamplerConfiguration is an object that encapsulates the SCColorSampler properties such as loupe size, quality, shape and others.
open class SCColorSamplerConfiguration: NSObject {
    
    // Stored properties
    private var _loupeSize: LoupeSize = .medium
    private var _quality: Quality = .good
    private var _zoomValues: Set<ZoomValue> = [.xs, .s, .m, .l, .xl, .xxl]
    private var _defaultZoom: ZoomValue = .m
    private var _loupeShape: LoupeShape = .roundedRect
    private var _showColorDescription: Bool = true
    private var _colorDescriptionMethod: (NSColor) -> String = { color in
        let red = Int((color.redComponent * 255).rounded())
        let green = Int((color.greenComponent * 255).rounded())
        let blue = Int((color.blueComponent * 255).rounded())
        let alpha = Int((color.alphaComponent * 255).rounded())
        
        if alpha == 255 {
            return String(format: "%02x%02x%02x", red, green, blue).uppercased()
        } else {
            return String(format: "%02x%02x%02x%02x", red, green, blue, alpha).uppercased()
        }
    }
    
    // MARK: - Loupe shape
    public enum LoupeShape {
        case rect
        case roundedRect
        case circle
        
        internal func path(in rect: CGRect) -> CGPath {
            let path = CGMutablePath()
            switch self {
            case .rect:
                path.addRect(rect)
            case .roundedRect:
                path.addRoundedRect(in: rect,
                                    cornerWidth: rect.width / 8,
                                    cornerHeight: rect.height / 8)
            case .circle:
                path.addEllipse(in: rect)
            }
            return path
        }
    }
    
    /// SCColorSamplerConfiguration property that specifies the color sampler loupe shape.
    ///
    /// - Possible values are:
    ///     * rect
    ///     * roundedRect (default)
    ///     * circle
    open var loupeShape: LoupeShape { get { _loupeShape } set { _loupeShape = newValue } }
    
    // MARK: - Loupe size
    public enum LoupeSize {
        case small
        case medium
        case large
        case custom(CGFloat)
        
        internal func getSize() -> CGSize {
            switch self {
            case .small:
                return .init(width: 96, height: 96)
            case .medium:
                return .init(width: 128, height: 128)
            case .large:
                return .init(width: 160, height: 160)
            case .custom(let value):
                return .init(width: value, height: value)
            }
        }
    }
    
    /// SCColorSamplerConfiguration property that specifies the color sampler loupe size.
    ///
    /// - Possible values are:
    ///     * small: a width and height of 96
    ///     * medium: a width and height of 128 (default)
    ///     * large: a width and height of 160
    ///     * custom(CGFloat): a width and height of choice
    open var loupeSize: LoupeSize { get { _loupeSize } set { _loupeSize = newValue } }
    
    // MARK: - Quality
    public enum Quality {
        case low
        case nominal
        case good
        case great
        
        internal func getMultiplier() -> CGFloat {
            switch self {
            case .low:
                0.75
            case .nominal:
                1.0
            case .good:
                1.5
            case .great:
                2.0
            }
        }
    }
    
    /// SCColorSamplerConfiguration property that specifies the quality inside the color sampler loupe.
    ///
    /// - Possible values are:
    ///     * low: 0.75 times the resolution of the display it's used on
    ///     * nominal: same resolution as the display it's used on
    ///     * good: 1.5 times the resolution of the display it's used on (default)
    ///     * great: 2 times the resolution of the display it's used on
    open var quality: Quality { get { _quality } set { _quality = newValue } }
    
    // MARK: - Zoom
    public enum ZoomValue: Int {
        case xs = 0
        case s = 1
        case m = 2
        case l = 3
        case xl = 4
        case xxl = 5
        
        internal func getPixelZoom(quality: Quality) -> CGFloat {
            self.getApertureSize() * quality.getMultiplier()
        }
        
        internal func getApertureSize() -> CGFloat {
            switch self {
            case .xs:
                5
            case .s:
                7
            case .m:
                11
            case .l:
                13
            case .xl:
                17
            case .xxl:
                21
            }
        }
        
        internal func getApertureLineWidth() -> CGFloat {
            switch self {
            case .xs:
                0.75
            case .s:
                0.75
            case .m:
                1.25
            case .l:
                1.25
            case .xl:
                1.75
            case .xxl:
                1.75
            }
        }
        
        internal func getInsetAmount() -> CGFloat {
            switch self {
            case .xs:
                0.5
            case .s:
                0.5
            case .m:
                1.0
            case .l:
                1.0
            case .xl:
                1.5
            case .xxl:
                1.5
            }
        }
        
        internal func getSquarePatternSize() -> CGFloat {
            switch self {
            case .xs:
                self.getApertureSize() * 0.96
            case .s:
                self.getApertureSize() * 0.96
            case .m:
                self.getApertureSize() * 0.90
            case .l:
                self.getApertureSize() * 0.90
            case .xl:
                self.getApertureSize() * 0.84
            case .xxl:
                self.getApertureSize() * 0.86
            }
        }
        
        internal func getSquarePatternDisplacement() -> CGFloat {
            switch self {
            case .xs:
                0.00
            case .s:
                0.00
            case .m:
                0.02
            case .l:
                0.02
            case .xl:
                0.06
            case .xxl:
                0.06
            }
        }
        
        internal func getNextZoom(available: Set<ZoomValue>) -> ZoomValue? {
            let orderedSet = available.sorted(by: { $0.rawValue < $1.rawValue })
            guard let nextZoom = orderedSet.first(where: { $0.rawValue > self.rawValue }) else {
                return nil
            }
            return nextZoom
        }
        
        internal func getPreviousZoom(available: Set<ZoomValue>) -> ZoomValue? {
            let orderedSet = available.sorted(by: { $0.rawValue > $1.rawValue })
            guard let previousZoom = orderedSet.first(where: { $0.rawValue < self.rawValue }) else {
                return nil
            }
            return previousZoom
        }
    }
    
    /// SCColorSamplerConfiguration property that specifies the possible zoom values. Set to empty array to disable zoom functionality. Set the `defaultZoomValue` property to set the starting zoom value.
    ///
    /// Define all the possible zoom values in an array like so: [.s, .m, .l, .xl]
    ///
    /// - Possible values are:
    ///     * .xs
    ///     * .s
    ///     * .m
    ///     * .l
    ///     * .xl
    ///     * .xxl
    ///
    /// - By default, all zoom values are allowed.
    open var zoomValues: Set<ZoomValue> {
        get { _zoomValues }
        set  {
            _zoomValues = newValue
            _zoomValues.insert(_defaultZoom)
        }
    }
    
    /// SCColorSamplerConfiguration property that specifies the starting zoom value. If the `zoomValues` array is empty, this will be zoom value that the loupe stays at.
    ///
    /// - Possible values are:
    ///     * .xs
    ///     * .s
    ///     * .m (default)
    ///     * .l
    ///     * .xl
    ///     * .xxl
    open var defaultZoomValue: ZoomValue {
        get { _defaultZoom } 
        set {
            _defaultZoom = newValue
            _zoomValues.insert(newValue)
        }
    }
    
    // MARK: - Color text description
    /// SCColorSamplerConfiguration property that specifies if the color text description will appear under the color loupe.
    ///
    /// - Possible values are:
    ///     * true (default)
    ///     * false
    open var showColorDescription: Bool {
        get { _showColorDescription }
        set { _showColorDescription = newValue }
    }
    
    /// SCColorSamplerConfiguration property that specifies how to obtain the color text description from the hoveredColor.
    ///
    /// Define a closure that takes a NSColor and returns a string.
    ///
    /// By default, the colorDescriptionMethod returns the hex value of the hoveredColor.
    open var colorDescriptionMethod: (NSColor) -> String {
        get { _colorDescriptionMethod }
        set { _colorDescriptionMethod = newValue }
    }
}
