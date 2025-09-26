//
//  SVGBuilder.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//


/// A result builder that enables declarative SVG construction with a SwiftUI-like syntax.
///
/// `SVGBuilder` provides a DSL for constructing SVG content in Swift code.
/// It transforms multiple statements in a closure into a single SVG value,
/// allowing for a natural, hierarchical representation of SVG structure.
///
/// Example:
/// ```swift
/// let icon = svg(width: 100, height: 100) {
///     circle(cx: 50, cy: 50, r: 40)
///     if showBorder {
///         rect(x: 0, y: 0, width: 100, height: 100)
///             .stroke("black")
///             .fill("none")
///     }
///     for point in points {
///         circle(cx: point.x, cy: point.y, r: 2)
///     }
/// }
/// ```
///
/// The `SVGBuilder` supports Swift language features like conditionals, loops,
/// and optional unwrapping within the SVG construction DSL.
@resultBuilder
public enum SVGBuilder {
    /// Combines an array of components into a single SVG component.
    ///
    /// - Parameter components: An array of SVG components to combine.
    /// - Returns: A single SVG component representing the array of components.
    public static func buildArray<Element: SVG>(_ components: [Element]) -> _SVGArray<Element> {
        _SVGArray(elements: components)
    }

    /// Creates an empty SVG component when no content is provided.
    ///
    /// - Returns: An empty SVG component.
    public static func buildBlock() -> SVGEmpty {
        SVGEmpty()
    }

    /// Passes through a single content component unchanged.
    ///
    /// - Parameter content: The SVG component to pass through.
    /// - Returns: The same SVG component.
    public static func buildBlock<Content: SVG>(_ content: Content) -> Content {
        content
    }

    /// Combines multiple SVG components into a tuple of components.
    ///
    /// - Parameter content: The SVG components to combine.
    /// - Returns: A tuple of SVG components.
    public static func buildBlock<each Content: SVG>(
        _ content: repeat each Content
    ) -> _SVGTuple<repeat each Content> {
        _SVGTuple(content: repeat each content)
    }

    /// Handles the "if" or "true" case in a conditional statement.
    ///
    /// - Parameter component: The SVG component for the "if" or "true" case.
    /// - Returns: A conditional SVG component representing the "if" or "true" case.
    public static func buildEither<First: SVG, Second: SVG>(
        first component: First
    ) -> _SVGConditional<First, Second> {
        .first(component)
    }

    /// Handles the "else" or "false" case in a conditional statement.
    ///
    /// - Parameter component: The SVG component for the "else" or "false" case.
    /// - Returns: A conditional SVG component representing the "else" or "false" case.
    public static func buildEither<First: SVG, Second: SVG>(
        second component: Second
    ) -> _SVGConditional<First, Second> {
        .second(component)
    }

    /// Converts any SVG expression to itself.
    ///
    /// - Parameter expression: The SVG expression to convert.
    /// - Returns: The same SVG expression.
    public static func buildExpression<T: SVG>(_ expression: T) -> T {
        expression
    }

    /// Converts a text expression to SVG text.
    ///
    /// - Parameter expression: The SVG text to convert.
    /// - Returns: The same SVG text.
    public static func buildExpression(_ expression: SVGText) -> SVGText {
        expression
    }

    /// Handles optional SVG components.
    ///
    /// - Parameter component: An optional SVG component.
    /// - Returns: The same optional SVG component.
    public static func buildOptional<T: SVG>(_ component: T?) -> T? {
        component
    }

    /// Finalizes the result of the builder.
    ///
    /// - Parameter component: The SVG component to finalize.
    /// - Returns: The final SVG component.
    public static func buildFinalResult<T: SVG>(_ component: T) -> T {
        component
    }
}

/// A container for an array of SVG elements.
///
/// This type is used internally by the `SVGBuilder` to handle
/// arrays of elements, such as those created by `for` loops.
public struct _SVGArray<Element: SVG>: SVG {
    /// The array of SVG elements contained in this container.
    let elements: [Element]

    /// Renders all elements in the array into the printer.
    ///
    /// - Parameters:
    ///   - svg: The SVG array to render.
    ///   - printer: The printer to render the SVG into.
    public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
        for element in svg.elements {
            Element._render(element, into: &printer)
        }
    }

    /// This type uses direct rendering and doesn't have a body.
    public var body: Never { fatalError() }
}

/// A type to represent conditional SVG content based on if/else conditions.
///
/// This type is used internally by the `SVGBuilder` to handle
/// conditional content created by `if`/`else` statements.
public enum _SVGConditional<First: SVG, Second: SVG>: SVG {
    /// Represents the "if" or "true" case.
    case first(First)
    /// Represents the "else" or "false" case.
    case second(Second)

    /// Renders either the first or second SVG component based on the case.
    ///
    /// - Parameters:
    ///   - svg: The conditional SVG to render.
    ///   - printer: The printer to render the SVG into.
    public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
        switch svg {
        case let .first(first):
            First._render(first, into: &printer)
        case let .second(second):
            Second._render(second, into: &printer)
        }
    }

    /// This type uses direct rendering and doesn't have a body.
    public var body: Never { fatalError() }
}

/// Represents plain text content in SVG, with proper XML escaping.
///
/// `SVGText` handles escaping special characters in text content to ensure
/// proper SVG/XML rendering without security vulnerabilities.
public struct SVGText: SVG {
    /// The raw text content.
    let text: String

    /// Creates a new SVG text component with the given text.
    ///
    /// - Parameter text: The text content to represent.
    public init(_ text: String) {
        self.text = text
    }

    /// Renders the text content with proper XML escaping.
    ///
    /// This method escapes special characters (`&`, `<`, `>`, `"`, `'`) to prevent XML injection
    /// and ensure the text renders correctly in an SVG document.
    ///
    /// - Parameters:
    ///   - svg: The SVG text to render.
    ///   - printer: The printer to render the SVG into.
    public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
        printer.bytes.reserveCapacity(printer.bytes.count + svg.text.utf8.count)
        for byte in svg.text.utf8 {
            switch byte {
            case UInt8(ascii: "&"):
                printer.bytes.append(contentsOf: "&amp;".utf8)
            case UInt8(ascii: "<"):
                printer.bytes.append(contentsOf: "&lt;".utf8)
            case UInt8(ascii: ">"):
                printer.bytes.append(contentsOf: "&gt;".utf8)
            case UInt8(ascii: "\""):
                printer.bytes.append(contentsOf: "&quot;".utf8)
            case UInt8(ascii: "'"):
                printer.bytes.append(contentsOf: "&apos;".utf8)
            default:
                printer.bytes.append(byte)
            }
        }
    }

    /// This type uses direct rendering and doesn't have a body.
    public var body: Never { fatalError() }

    /// Concatenates two SVG text components.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side text.
    ///   - rhs: The right-hand side text.
    /// - Returns: A new SVG text component containing the concatenated text.
    public static func + (lhs: Self, rhs: Self) -> Self {
        SVGText(lhs.text + rhs.text)
    }
}

/// Allows SVG text to be created from string literals.
extension SVGText: ExpressibleByStringLiteral {
    /// Creates a new SVG text component from a string literal.
    ///
    /// - Parameter value: The string literal to use as content.
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

/// Allows SVG text to be created with string interpolation.
extension SVGText: ExpressibleByStringInterpolation {}

/// A container for a tuple of SVG elements.
///
/// This type is used internally by the `SVGBuilder` to handle
/// multiple SVG elements combined in a single block.
public struct _SVGTuple<each Content: SVG>: SVG {
    /// The tuple of SVG elements.
    let content: (repeat each Content)

    /// Creates a new tuple of SVG elements.
    ///
    /// - Parameter content: The tuple of SVG elements.
    init(content: repeat each Content) {
        self.content = (repeat each content)
    }

    /// Renders all elements in the tuple into the printer.
    ///
    /// - Parameters:
    ///   - svg: The SVG tuple to render.
    ///   - printer: The printer to render the SVG into.
    public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
        func render<T: SVG>(_ svg: T) {
            T._render(svg, into: &printer)
        }
        repeat render(each svg.content)
    }

    /// This type uses direct rendering and doesn't have a body.
    public var body: Never { fatalError() }
}

/// Allows optional values to be used as SVG elements.
///
/// This conformance allows for convenient handling of optional SVG content,
/// where `nil` values simply render nothing.
extension Optional: SVG where Wrapped: SVG {
    /// Renders the optional SVG element if it exists.
    ///
    /// - Parameters:
    ///   - svg: The optional SVG to render.
    ///   - printer: The printer to render the SVG into.
    public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
        guard let svg else { return }
        Wrapped._render(svg, into: &printer)
    }

    /// This type uses direct rendering and doesn't have a body.
    public var body: Never { fatalError() }
}