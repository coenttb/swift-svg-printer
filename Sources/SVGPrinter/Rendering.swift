//
//  Rendering.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

import Foundation

extension SVG {
    /// Renders the SVG to Data.
    ///
    /// - Parameter configuration: The printer configuration to use.
    /// - Returns: The rendered SVG as Data.
    public func renderData(_ configuration: SVGPrinter.Configuration = .default) -> Data {
        Data(renderBytes(configuration))
    }
}

// MARK: - Document Rendering

/// Creates a complete SVG document with XML declaration and DOCTYPE.
public struct Document: SVG {
    let content: any SVG
    let includeXMLDeclaration: Bool
    let includeDOCTYPE: Bool

    /// Creates a new SVG document.
    ///
    /// - Parameters:
    ///   - includeXMLDeclaration: Whether to include the XML declaration.
    ///   - includeDOCTYPE: Whether to include the DOCTYPE declaration.
    ///   - content: The SVG content.
    public init(
        includeXMLDeclaration: Bool = true,
        includeDOCTYPE: Bool = false,
        @SVGBuilder content: () -> some SVG
    ) {
        self.content = content()
        self.includeXMLDeclaration = includeXMLDeclaration
        self.includeDOCTYPE = includeDOCTYPE
    }

    public static func _render(_ svg: Document, into printer: inout SVGPrinter) {
        if svg.includeXMLDeclaration {
            printer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
            printer.appendNewlineIfNeeded()
        }

        if svg.includeDOCTYPE {
            printer.append("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">")
            printer.appendNewlineIfNeeded()
        }

        renderContent(svg.content, into: &printer)
    }

    public var body: Never { fatalError() }
}

private func renderContent<T: SVG>(_ content: T, into printer: inout SVGPrinter) {
    T._render(content, into: &printer)
}