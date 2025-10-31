# swift-svg-printer

[![CI](https://github.com/coenttb/swift-svg-printer/workflows/CI/badge.svg)](https://github.com/coenttb/swift-svg-printer/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Renders SVG types to strings and bytes for cross-platform SVG generation.

## Overview

swift-svg-printer provides the rendering layer for the SVG type system, converting `swift-svg-types` elements into SVG markup as strings or byte arrays.

## Features

- Renders to `ContiguousArray<UInt8>` for memory efficiency
- String conversion via `render()` method
- Attribute escaping and formatting for valid SVG output
- Configurable indentation and pretty-printing
- Dependencies: swift-svg-types, swift-collections, swift-dependencies

## Installation

Add swift-svg-printer to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-svg-printer", from: "0.1.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "SVGPrinter", package: "swift-svg-printer")
        ]
    )
]
```

## Quick Start

```swift
import SVGPrinter

// Create a printer
var printer = SVGPrinter()

// Build SVG markup
printer.append("<circle cx=\"50\" cy=\"50\" r=\"40\"/>")

// Get result as string
let svgString = String(decoding: printer.bytes, as: UTF8.self)
// Output: <circle cx="50" cy="50" r="40"/>
```

## Usage Examples

### Pretty Printing

```swift
import SVGPrinter

var printer = SVGPrinter(.pretty)
printer.append("<svg>")
printer.appendNewlineIfNeeded()
printer.indent()
printer.appendIndentationIfNeeded()
printer.append("<circle cx=\"50\" cy=\"50\" r=\"40\"/>")
printer.outdent()
printer.appendNewlineIfNeeded()
printer.append("</svg>")

let output = String(decoding: printer.bytes, as: UTF8.self)
```

### Attribute Management

```swift
import SVGPrinter
import OrderedCollections

var printer = SVGPrinter()
printer.attributes["fill"] = "red"
printer.attributes["stroke"] = "black"

// Attributes can be accessed and managed
let fillColor = printer.attributes["fill"] // "red"
```

## Related Packages

- [swift-svg-types](https://github.com/coenttb/swift-svg-types): A Swift package with foundational types for SVG.
- [swift-svg](https://github.com/coenttb/swift-svg): A Swift package for type-safe SVG generation.
- [swift-html](https://github.com/coenttb/swift-html): The Swift library for domain-accurate and type-safe HTML & CSS.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for details.