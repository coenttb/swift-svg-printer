//
//  SVG.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

import Dependencies

/// A protocol representing an SVG element or component that can be rendered.
///
/// The `SVG` protocol is the core abstraction of the swift-svg library,
/// allowing Swift types to represent SVG content in a declarative, composable manner.
/// It uses a component-based architecture similar to SwiftUI and PointFreeHTML,
/// where each component defines its `body` property to build up a hierarchy of SVG elements.
///
/// Example:
/// ```swift
/// struct MyIcon: SVG {
///     var body: some SVG {
///         svg(width: 100, height: 100) {
///             circle(cx: 50, cy: 50, r: 40) {
///                 fill("red")
///                 stroke("black", width: 3)
///             }
///         }
///     }
/// }
/// ```
///
/// - Note: This protocol follows the same design as PointFreeHTML's `HTML` protocol,
///   making it familiar to developers who have worked with either SwiftUI or PointFreeHTML.
public protocol SVG {
  /// The type of SVG content that this SVG element or component contains.
  associatedtype Content: SVG

  /// The body of this SVG element or component, defining its structure and content.
  ///
  /// This property uses the `SVGBuilder` result builder to allow for a declarative
  /// syntax when defining SVG content.
  @SVGBuilder
  var body: Content { get }

  /// Renders this SVG element or component into the provided printer.
  ///
  /// This method is typically not called directly by users of the library,
  /// but is used internally to convert the SVG tree into rendered output.
  ///
  /// - Parameters:
  ///   - svg: The SVG element or component to render.
  ///   - printer: The printer to render the SVG into.
  static func _render(_ svg: Self, into printer: inout SVGPrinter)
}

extension SVG {
  /// Default implementation of the render method that delegates to the body's render method.
  public static func _render(_ svg: Self, into printer: inout SVGPrinter) {
    Content._render(svg.body, into: &printer)
  }
}

/// Conformance of `Never` to `SVG` to support the type system.
///
/// This conformance is provided to allow the use of the `SVG` protocol in
/// contexts where no content is expected or possible.
extension Never: SVG {
  public static func _render(_ svg: Self, into printer: inout SVGPrinter) {}
  public var body: Never { fatalError() }
}

/// Type-erased SVG element that can hold any SVG content.
public struct AnySVG: SVG {
  let base: any SVG

  public init(_ base: any SVG) {
    self.base = base
  }

  public static func _render(_ svg: AnySVG, into printer: inout SVGPrinter) {
    func render<T: SVG>(_ svg: T) {
      T._render(svg, into: &printer)
    }
    render(svg.base)
  }

  public var body: Never { fatalError() }
}

extension AnySVG {
  public init(_ closure: () -> any SVG) {
    self = .init(closure())
  }
}
