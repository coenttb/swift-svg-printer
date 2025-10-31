//
//  Attributes.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

import Foundation
import OrderedCollections
import SVGTypes

/// An SVG element that adds an attribute to the printer.
public struct Attribute: SVG {
  let key: String
  let value: String

  public static func _render(_ svg: Attribute, into printer: inout SVGPrinter) {
    printer.attributes[svg.key] = svg.value
  }

  public var body: Never { fatalError() }
}

// Helper function to format numeric values for attributes
private func formatValue(_ value: Double) -> String {
  value.truncatingRemainder(dividingBy: 1) == 0
    ? value.formatted(.number.precision(.fractionLength(0)).locale(Locale(identifier: "en_US")))
    : value.formatted(.number.locale(Locale(identifier: "en_US")))
}

// MARK: - Common Attributes

/// Sets the fill color.
public func fill(_ color: String) -> Attribute {
  Attribute(key: "fill", value: color)
}

/// Sets the stroke color.
public func stroke(_ color: String) -> Attribute {
  Attribute(key: "stroke", value: color)
}

/// Sets the stroke width.
public func strokeWidth(_ width: Double) -> Attribute {
  Attribute(key: "stroke-width", value: formatValue(width))
}

/// Sets the stroke color and width.
public func stroke(_ color: String, width: Double) -> some SVG {
  SVGGroup {
    stroke(color)
    strokeWidth(width)
  }
}

/// Sets the opacity.
public func opacity(_ value: Double) -> Attribute {
  Attribute(key: "opacity", value: formatValue(value))
}

/// Sets the fill opacity.
public func fillOpacity(_ value: Double) -> Attribute {
  Attribute(key: "fill-opacity", value: formatValue(value))
}

/// Sets the stroke opacity.
public func strokeOpacity(_ value: Double) -> Attribute {
  Attribute(key: "stroke-opacity", value: formatValue(value))
}

/// Sets the stroke linecap.
public func strokeLinecap(_ value: SVGLineCap) -> Attribute {
  Attribute(key: "stroke-linecap", value: value.rawValue)
}

/// Sets the stroke linejoin.
public func strokeLinejoin(_ value: SVGLineJoin) -> Attribute {
  Attribute(key: "stroke-linejoin", value: value.rawValue)
}

/// Sets the stroke dash array.
public func strokeDasharray(_ values: Double...) -> Attribute {
  Attribute(key: "stroke-dasharray", value: values.map { formatValue($0) }.joined(separator: " "))
}

/// Sets the stroke dash array.
public func strokeDasharray(_ values: [Double]) -> Attribute {
  Attribute(key: "stroke-dasharray", value: values.map { formatValue($0) }.joined(separator: " "))
}

/// Sets the stroke dash offset.
public func strokeDashoffset(_ value: Double) -> Attribute {
  Attribute(key: "stroke-dashoffset", value: formatValue(value))
}

/// Sets the miter limit for stroke linejoin.
public func strokeMiterlimit(_ value: Double) -> Attribute {
  Attribute(key: "stroke-miterlimit", value: formatValue(value))
}

// MARK: - Transform

/// Sets the transform attribute.
public func transform(_ transforms: SVGTransform...) -> Attribute {
  let value = transforms.map { $0.stringValue }.joined(separator: " ")
  return Attribute(key: "transform", value: value)
}

/// Sets the transform attribute.
public func transform(_ transforms: [SVGTransform]) -> Attribute {
  let value = transforms.map { $0.stringValue }.joined(separator: " ")
  return Attribute(key: "transform", value: value)
}

// MARK: - Presentation Attributes

/// Sets the display property.
public func display(_ value: String) -> Attribute {
  Attribute(key: "display", value: value)
}

/// Sets the visibility property.
public func visibility(_ value: String) -> Attribute {
  Attribute(key: "visibility", value: value)
}

/// Sets the clip-path property.
public func clipPath(_ value: String) -> Attribute {
  Attribute(key: "clip-path", value: value)
}

/// Sets the mask property.
public func mask(_ value: String) -> Attribute {
  Attribute(key: "mask", value: value)
}

/// Sets the filter property.
public func filter(_ value: String) -> Attribute {
  Attribute(key: "filter", value: value)
}

// MARK: - Text Attributes

/// Sets the font family.
public func fontFamily(_ value: String) -> Attribute {
  Attribute(key: "font-family", value: value)
}

/// Sets the font size.
public func fontSize(_ value: Double) -> Attribute {
  Attribute(key: "font-size", value: formatValue(value))
}

/// Sets the font weight.
public func fontWeight(_ value: String) -> Attribute {
  Attribute(key: "font-weight", value: value)
}

/// Sets the font style.
public func fontStyle(_ value: String) -> Attribute {
  Attribute(key: "font-style", value: value)
}

/// Sets the text anchor.
public func textAnchor(_ value: String) -> Attribute {
  Attribute(key: "text-anchor", value: value)
}

/// Sets the text decoration.
public func textDecoration(_ value: String) -> Attribute {
  Attribute(key: "text-decoration", value: value)
}

/// Sets the letter spacing.
public func letterSpacing(_ value: Double) -> Attribute {
  Attribute(key: "letter-spacing", value: formatValue(value))
}

/// Sets the word spacing.
public func wordSpacing(_ value: Double) -> Attribute {
  Attribute(key: "word-spacing", value: formatValue(value))
}

// MARK: - Core Attributes

/// Sets the ID attribute.
public func id(_ value: String) -> Attribute {
  Attribute(key: "id", value: value)
}

/// Sets the class attribute.
public func svgClass(_ value: String) -> Attribute {
  Attribute(key: "class", value: value)
}

/// Sets the style attribute.
public func style(_ value: String) -> Attribute {
  Attribute(key: "style", value: value)
}

/// Sets a custom attribute.
public func attribute(_ key: String, _ value: String) -> Attribute {
  Attribute(key: key, value: value)
}
