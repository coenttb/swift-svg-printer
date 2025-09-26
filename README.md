# swift-svg-printer

A cross-platform Swift package to render SVG types as strings and bytes.

## Overview

swift-svg-printer enables SVG elements from `swift-svg-types` to be rendered as SVG strings and byte arrays through an efficient printing system. It provides the rendering engine for the SVG ecosystem.

## Key Features

- **Efficient Rendering**: SVGPrinter renders to bytes (`ContiguousArray<UInt8>`) for performance
- **String Conversion**: Simple conversion to String for convenience
- **Attribute Handling**: Properly escapes and formats all SVG attributes
- **Nested Elements**: Handles complex SVG hierarchies with proper indentation
- **Minimal Dependencies**: Only depends on swift-svg-types

## Usage Examples

### Basic Usage

```swift
import SVGTypes
import SVGPrinter

let circle = Circle(cx: 50, cy: 50, r: 40, fill: "blue")
let svgString = String(svg: circle)
// <circle cx="50" cy="50" r="40" fill="blue"/>

let svgBytes: ContiguousArray<UInt8> = SVGPrinter.render(circle)
```

### Complex SVG

```swift
import SVGTypes
import SVGPrinter

let svg = SVG(width: 200, height: 200) {
    Defs {
        LinearGradient(id: "gradient", x1: "0%", y1: "0%", x2: "100%", y2: "100%") {
            Stop(offset: "0%", stopColor: "red")
            Stop(offset: "100%", stopColor: "blue")
        }
    }
    Circle(cx: 100, cy: 100, r: 80, fill: "url(#gradient)")
}

let svgString = String(svg: svg)
```

## Integration with Swift Ecosystem

### swift-svg Integration

[swift-svg](https://github.com/coenttb/swift-svg) provides a complete DSL built on top of swift-svg-printer:

```swift
import SVG

let icon = SVG {
    Circle()
        .cx(50)
        .cy(50)
        .r(40)
        .fill(.blue)
        .stroke(.black)
        .strokeWidth(2)
}

let rendered = String(svg: icon)
```

### HTML Integration

Integrate with [swift-html](https://github.com/coenttb/swift-html) for embedding SVG in HTML:

```swift
import HTML
import SVG

struct IconButton: HTML {
    var body: some HTML {
        button {
            SVG(width: 24, height: 24) {
                Path(d: "M12 2L2 7l10 5 10-5-10-5z")
                    .fill("currentColor")
            }
            "Click me"
        }
    }
}
```

## Performance

swift-svg-printer is optimized for performance:
- Direct byte rendering avoids string allocations
- Efficient attribute escaping
- Minimal memory overhead
- Suitable for server-side rendering at scale

## Installation

### Swift Package Manager

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

### Xcode Project

Add the package dependency in Xcode:
- File → Add Package Dependencies
- Enter: `https://github.com/coenttb/swift-svg-printer`

## Testing

swift-svg-printer includes support for snapshot testing:

```swift
import SVGPrinterTestSupport

@Test
func testCircle() {
    let circle = Circle(cx: 50, cy: 50, r: 40)
    assertInlineSnapshot(of: circle, as: .svg) {
        """
        <circle cx="50" cy="50" r="40"/>
        """
    }
}
```

## Related Projects

swift-svg-printer is part of a comprehensive Swift SVG ecosystem:

### Core Libraries
- [swift-svg-types](https://github.com/coenttb/swift-svg-types): Type-safe SVG element definitions
- [swift-svg](https://github.com/coenttb/swift-svg): Complete SVG DSL with builder syntax
- [swift-html](https://github.com/coenttb/swift-html): HTML generation with SVG integration

### Server Integration
- [coenttb-server](https://github.com/coenttb/coenttb-server): Modern Swift server framework
- [swift-web](https://github.com/coenttb/swift-web): Modular web development tools

## Real-World Usage

swift-svg-printer powers production applications:

- **[coenttb.com](https://coenttb.com)**: Dynamic SVG generation for icons and graphics
- **[coenttb-com-server](https://github.com/coenttb/coenttb-com-server)**: Server-side SVG rendering

Using `swift-svg-printer` in your project? Open an issue or submit a PR to add your project to this list!

## Documentation

Comprehensive documentation is available at the [Swift Package Index](https://swiftpackageindex.com/coenttb/swift-svg-printer/main/documentation/svgprinter).

## Contributing

Contributions are welcome! Please feel free to:

- Open issues for bugs or feature requests
- Submit pull requests
- Improve documentation
- Share your projects built with swift-svg-printer

## Feedback & Support

- **Issues**: [GitHub Issues](https://github.com/coenttb/swift-svg-printer/issues)
- **Newsletter**: [Subscribe](http://coenttb.com/en/newsletter/subscribe)
- **Social**: [Follow @coenttb](http://x.com/coenttb)
- **Professional**: [LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

This project is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for details.