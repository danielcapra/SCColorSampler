//
//  SCColorSampler.swift
//
//
//  Created by Daniel Capra on 29/10/2023.
//

import AppKit
import struct Combine.AnyPublisher
import Foundation

public class SCColorSampler: NSObject {
    private override init() {}
    /// Displays the color loupe and allows the user to select a color.
    ///
    /// - Important: Requires screen sharing permissions!
    ///
    /// - Parameters:
    ///     - hoverHandler: The handler block for processing the color at the mouse's current location.
    ///     - selectionHandler: The handler block for processing the user-selected color. This block has no return value. The parameter will come back as nil if user cancels the selection (ie. they press the ESC key)
    ///
    /// - Attention: Will ask for screen sharing permission if it hasn't been asked for already.
    ///
    /// ```swift
    /// // Example
    /// let configuration = SCColorSamplerConfiguration()
    /// // Change all configuration attributes you need like so
    /// configuration.loupeShape = .circle
    /// configuration.loupeSize = .large
    /// // ...
    /// SCColorSampler.sample(configuration: configuration) { hoveredColor in
    ///     // Do something with the hoveredColor...
    ///     self.hoveredColor = hoveredColor
    /// }, selectionHandler: { selectedColor in
    ///     // selectedColor will be nil if user cancelled or if an error occured
    ///     guard let selectedColor = selectedColor else {
    ///         return
    ///     }
    ///     // Do something with the selectedColor...
    ///     self.selectedColor = selectedColor
    /// }
    /// ```
    ///
    ///  - Author: Daniel Capra @ danielcapra.com
    public static func sample(
        configuration: SCColorSamplerConfiguration,
        hoverHandler: ((_ hoveredColor: NSColor) -> Void)? = nil,
        selectionHandler: @escaping (_ selectedColor: NSColor?) -> Void
    ) {
        let hasScreenCaptureAccess = CGPreflightScreenCaptureAccess()
        if hasScreenCaptureAccess {
            ColorSampler.shared.sample(
                onMouseMoved: hoverHandler ?? { _ in },
                selectionHandler: selectionHandler,
                configuration: configuration
            )
        }
    }
}
