//
//  Element.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

import SVGTypes
import OrderedCollections
import Foundation

/// A concrete SVG element with its content.
public struct Element<ElementType: SVGElementType>: SVG {
    /// The element type.
    public let element: ElementType

    /// The content of the element.
    public let content: any SVG

    /// Creates a new element with content.
    ///
    /// - Parameters:
    ///   - element: The element type.
    ///   - content: The content of the element.
    public init(_ element: ElementType, content: any SVG) {
        self.element = element
        self.content = content
    }

    public static func _render(_ svg: Element<ElementType>, into printer: inout SVGPrinter) {
        // First, collect attributes and check for content using a temporary printer
        var tempPrinter = SVGPrinter(printer.configuration)
        tempPrinter.currentIndentation = printer.currentIndentation
        renderContent(svg.content, into: &tempPrinter)

        let collectedAttributes = tempPrinter.attributes
        let hasChildContent = !tempPrinter.bytes.isEmpty

        // Start tag
        printer.appendIndentationIfNeeded()
        printer.append("<\(ElementType.tagName)")

        // Add attributes from the element
        renderAttributes(for: svg.element, into: &printer)

        // Add collected attributes from content
        for (key, value) in collectedAttributes {
            printer.append(" \(key)=\"\(value)\"")
        }

        if ElementType.isSelfClosing && !hasChildContent {
            printer.append("/>")
            printer.appendNewlineIfNeeded()
        } else {
            printer.append(">")

            // Handle text content for Text and TSpan elements
            if let textElement = svg.element as? Text, let text = textElement.content {
                printer.append(text)
            } else if let tspanElement = svg.element as? TSpan, let text = tspanElement.content {
                printer.append(text)
            } else if hasChildContent {
                // Render actual child content with proper indentation
                printer.appendNewlineIfNeeded()
                printer.indent()
                renderContent(svg.content, into: &printer)
                printer.outdent()
                printer.appendIndentationIfNeeded()
            }

            // End tag
            printer.append("</\(ElementType.tagName)>")
            // Only append newline if we're not at the root level
            if !printer.currentIndentation.isEmpty {
                printer.appendNewlineIfNeeded()
            }
        }
    }

    public var body: Never { fatalError() }
}

// Helper function to check if content is empty
private func isContentEmpty(_ content: any SVG) -> Bool {
    if content is Never { return true }
    if let _ = content as? Never { return true }
    return false
}

// Helper function to render content
private func renderContent<T: SVG>(_ content: T, into printer: inout SVGPrinter) {
    T._render(content, into: &printer)
}

// Helper function to render attributes for each element type
private func renderAttributes<T: SVGElementType>(for element: T, into printer: inout SVGPrinter) {
    let mirror = Mirror(reflecting: element)

    for child in mirror.children {
        guard let label = child.label else { continue }

        // Skip static properties and content
        if label == "tagName" || label == "isSelfClosing" || label == "content" {
            continue
        }

        // Convert property name to kebab-case (except for viewBox which stays as is)
        let attributeName = label == "viewBox" ? "viewBox" : camelToKebab(label)

        // Handle different value types
        if let value = child.value as? String {
            printer.append(" \(attributeName)=\"\(value)\"")
        } else if let value = child.value as? Double {
            let formatted = value.truncatingRemainder(dividingBy: 1) == 0 ?
                value.formatted(.number.precision(.fractionLength(0)).locale(Locale(identifier: "en_US"))) :
                value.formatted(.number.locale(Locale(identifier: "en_US")))
            printer.append(" \(attributeName)=\"\(formatted)\"")
        } else if let value = child.value as? Int {
            printer.append(" \(attributeName)=\"\(value)\"")
        } else if let value = child.value as? Bool, value {
            printer.append(" \(attributeName)=\"\(attributeName)\"")
        } else if let transforms = child.value as? [SVGTransform] {
            let transformString = transforms.map { $0.stringValue }.joined(separator: " ")
            printer.append(" transform=\"\(transformString)\"")
        } else if let fillRule = child.value as? SVGFillRule {
            printer.append(" fill-rule=\"\(fillRule.rawValue)\"")
        } else if let units = child.value as? ClipPath.ClipPathUnits {
            printer.append(" \(attributeName)=\"\(units.rawValue)\"")
        } else if let units = child.value as? Mask.MaskUnits {
            printer.append(" \(attributeName)=\"\(units.rawValue)\"")
        } else if let units = child.value as? LinearGradient.GradientUnits {
            printer.append(" \(attributeName)=\"\(units.rawValue)\"")
        } else if let units = child.value as? RadialGradient.GradientUnits {
            printer.append(" \(attributeName)=\"\(units.rawValue)\"")
        } else if let method = child.value as? LinearGradient.SpreadMethod {
            printer.append(" \(attributeName)=\"\(method.rawValue)\"")
        } else if let method = child.value as? RadialGradient.SpreadMethod {
            printer.append(" \(attributeName)=\"\(method.rawValue)\"")
        } else if let units = child.value as? Pattern.PatternUnits {
            printer.append(" \(attributeName)=\"\(units.rawValue)\"")
        } else if let units = child.value as? Marker.MarkerUnits {
            printer.append(" \(attributeName)=\"\(units.rawValue)\"")
        } else if let lengthAdjust = child.value as? Text.TextLengthAdjust {
            printer.append(" \(attributeName)=\"\(lengthAdjust.rawValue)\"")
        } else if let length = child.value as? SVGLength {
            printer.append(" \(attributeName)=\"\(length.stringValue)\"")
        } else if let viewBox = child.value as? SVGViewBox {
            printer.append(" \(attributeName)=\"\(viewBox.stringValue)\"")
        }
    }
}

// Helper function to convert camelCase to kebab-case
private func camelToKebab(_ input: String) -> String {
    var result = ""
    for (index, character) in input.enumerated() {
        if character.isUppercase && index > 0 {
            result += "-"
        }
        result += character.lowercased()
    }
    return result
}