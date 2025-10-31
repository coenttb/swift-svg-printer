//
//  SVGEmpty.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

/// An empty SVG element that renders nothing.
///
/// This type is useful as a placeholder or when conditionally
/// rendering content that might be empty.
public struct SVGEmpty: SVG {
  /// Creates an empty SVG element.
  public init() {}

  /// Renders nothing into the printer.
  public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
    // Intentionally empty
  }

  public var body: Never { fatalError() }
}
