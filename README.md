# SCColorSampler

[![](https://img.shields.io/badge/ScreenCaptureKit-blue)](https://developer.apple.com/documentation/screencapturekit/)
![](https://img.shields.io/badge/Platform-macOS%2012.3%2B-red) 
![](https://img.shields.io/badge/Swift-5.4-orange.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) 
[![](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A Swift 5.4, highly-customizable, ScreenCaptureKit-based color sampler.

## Overview

Adapted from [https://github.com/dagronf/DSFColorSampler](https://github.com/dagronf/DSFColorSampler) for ScreenCaptureKit and with some minor improvements and more customization.

`Requires screen sharing permission!`

![](./readme_assets/example.gif)

## Why?
While Apple does offer `NSColorSampler()` as a native solution, it is not customizable and so it might not fit everyone's needs.

Also with the release of macOS 14.0 (Sonoma), Apple deprecated `CGWindowListCreateImage` which was previously used for multiple custom color sampler packages.

## Features

* Highly customizable to fit every project's needs
* Simple block callbacks
* Hit Escape to cancel picking
* Use the mouse scroll wheel | pinch gesture to zoom in and zoom out

## Usage

### Swift Package Manager

Add `https://github.com/danielcapra/SCColorSampler` to your project.

## API

```swift
let configuration = SCColorSamplerConfiguration()

SCColorSampler.sample(configuration: configuration) { hoveredColor in
    // Do something with the hoveredColor
    // ...
} selectionHandler: { selectedColor in 
    // Check if user cancelled
    guard let selectedColor = selectedColor else {
        return
    }
    // Do something with the selectedColor
    // ...
}
```

### Configuration customization examples

#### Loupe shape
<p float="left">
<img alt="Image showing rounded rectangle loupe shape option" src="./readme_assets/roundedRect.png" width="100" height="100">
<img alt="Image showing rectangle loupe shape option" src="./readme_assets/rect.png" width="100" height="100">
<img alt="Image showing circle loupe shape option" src="./readme_assets/circle.png" width="100" height="100">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

configuration.loupeShape = .roundedRect // default
// or
configuration.loupeShape = .circle
// or
configuration.loupeShape = .rect

SCColorSampler.sample(configuration: configuration) { ... }
```

#### Loupe size
<p float="left">
<img alt="Image showing small loupe size option" src="./readme_assets/small.png" width="100" height="100">
<img alt="Image showing medium loupe size option" src="./readme_assets/medium.png" width="100" height="100">
<img alt="Image showing large loupe size option" src="./readme_assets/large.png" width="100" height="100">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

configuration.loupeSize = .small
// or
configuration.loupeSize = .medium // default
// or
configuration.loupeSize = .large
// or
configuration.loupeSize = .custom(256) // custom CGFloat value

SCColorSampler.sample(configuration: configuration) { ... }
```

#### Quality
<p float="left">
<img alt="Image showing low quality option" src="./readme_assets/low.png" width="100" height="100">
<img alt="Image showing nominal quality option" src="./readme_assets/nominal.png" width="100" height="100">
<img alt="Image showing good quality option" src="./readme_assets/good.png" width="100" height="100">
<img alt="Image showing great quality option" src="./readme_assets/great.png" width="100" height="100">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

configuration.quality = .low
// or
configuration.quality = .nominal
// or
configuration.quality = .good // default
// or
configuration.quality = .great

SCColorSampler.sample(configuration: configuration) { ... }
```

#### Zoom starting value
This will be the starting zoom value each time the color sampler function is called and the loupe appears.

<p float="left">
<img alt="Image showing xs zoom option" src="./readme_assets/xs.png" width="100" height="100">
<img alt="Image showing s zoom option" src="./readme_assets/s.png" width="100" height="100">
<img alt="Image showing m zoom option" src="./readme_assets/m.png" width="100" height="100">
<img alt="Image showing l zoom option" src="./readme_assets/l.png" width="100" height="100">
<img alt="Image showing xl zoom option" src="./readme_assets/xl.png" width="100" height="100">
<img alt="Image showing xxl zoom option" src="./readme_assets/xxl.png" width="100" height="100">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

configuration.defaultZoomValue = .xs
// or
configuration.defaultZoomValue = .s
// or
configuration.defaultZoomValue = .m // default
// or
configuration.defaultZoomValue = .l
// or
configuration.defaultZoomValue = .xl
// or
configuration.defaultZoomValue = .xxl

SCColorSampler.sample(configuration: configuration) { ... }
```

#### Zoom available values
These will be the zoom values the user is allowed to scrub through.

Note: If the `defaultZoomValue` is not included in the `zoomValues` array, it will automatically be added to it.
```swift
// For example:
configuration.defaultZoomValue = .xs
configuration.zoomValues = [.s, .m]
// The zoom values the user will be allowed to scrub through will be [.xs, .s, .m]
```

<p float="left">
<img alt="Image showing [.xs, .s] zoomValues option" src="./readme_assets/xs_s.gif" width="100" height="100">
<img alt="Image showing [.xs, .s, .m] zoomValues option" src="./readme_assets/xs_s_m.gif" width="100" height="100">
<img alt="Image showing [.xs, .s, .m, .l] zoomValues option" src="./readme_assets/xs_s_m_l.gif" width="100" height="100">
<img alt="Image showing [.xs, .s, .m, .l, .xl] zoomValues option" src="./readme_assets/xs_s_m_l_xl.gif" width="100" height="100">
<img alt="Image showing [.xs, .s, .m, .l, .xl, .xxl] zoomValues option" src="./readme_assets/xs_s_m_l_xl_xxl.gif" width="100" height="100">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

configuration.defaultZoomValue = .xs
configuration.zoomValues = [] // Zoom functionality disabled
// or
configuration.zoomValues = [.xs] // If the only element in the array matches the defaultZoomValue that also results in the zoom functionality being disabled
// or
configuration.zoomValues = [.xs, .s]
// or
configuration.zoomValues = [.xs, .s, .m]
// or
configuration.zoomValues = [.xs, .s, .m, .l]
// or
configuration.zoomValues = [.xs, .s, .m, .l, .xl]
// or
configuration.zoomValues = [.xs, .s, .m, .l, .xl, .xxl] // Default

SCColorSampler.sample(configuration: configuration) { ... }
```

#### Show Color Description
<p float="left">
<img alt="Image showing showColorDescription off option" src="./readme_assets/off.png" width="100" height="125">
<img alt="Image showing showColorDescription on option" src="./readme_assets/on.png" width="100" height="125">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

configuration.showColorDescription = false
// or
configuration.showColorDescription = true // default

SCColorSampler.sample(configuration: configuration) { ... }
```

#### Color Description Method
Customize the color description shown under the color loupe with your own method that takes in a NSColor and returns a string.

<p float="left">
<img alt="Image showing colorDescriptionMethod that shows hex values" src="./readme_assets/hex.png" width="100" height="125">
<img alt="Image showing colorDescriptionMethod that shows rgb values" src="./readme_assets/rgb.png" width="100" height="125">
</p>

```swift
let configuration = SCColorSamplerConfiguration()

// Any closure of type (NSColor) -> String
configuration.colorDescriptionMethod = { hoveredColor in
    // Returns hex string (default)
    let red = Int((hoveredColor.redComponent * 255).rounded())
    let green = Int((hoveredColor.greenComponent * 255).rounded())
    let blue = Int((hoveredColor.blueComponent * 255).rounded())
    
    return String(
        format: "%02x%02x%02x",
        red,
        green,
        blue
    ).uppercased()
}
// or
configuration.colorDescriptionMethod = { hoveredColor in
    // Returns rgb values
    let red = Int((hoveredColor.redComponent * 255).rounded())
    let green = Int((hoveredColor.greenComponent * 255).rounded())
    let blue = Int((hoveredColor.blueComponent * 255).rounded())
    
    return "\(red) | \(green) | \(blue)"
}

SCColorSampler.sample(configuration: configuration) { ... }
```

# License

```
MIT License

Copyright (c) 2023 Daniel Capra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
