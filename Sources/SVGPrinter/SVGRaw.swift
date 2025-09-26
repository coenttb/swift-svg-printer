//
//  SVGRaw.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

/// An SVG element that renders raw SVG content without escaping.
///
/// Use this type when you need to include pre-formatted SVG content
/// or when working with SVG strings from external sources.
///
/// - Warning: Content is not escaped. Ensure the SVG content is safe
///   and properly formatted to avoid injection vulnerabilities.
public struct SVGRaw: SVG {
    /// The raw SVG content to render.
    let content: String

    /// Creates a raw SVG element with the given content.
    ///
    /// - Parameter content: The raw SVG content to render.
    public init(_ content: String) {
        self.content = content
    }

    /// Renders the raw content directly into the printer.
    public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
        printer.append(svg.content)
    }

    public var body: Never { fatalError() }
}