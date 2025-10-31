//
//  SVGPrinter.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

import Dependencies
import OrderedCollections

/// A struct responsible for rendering SVG elements to bytes.
///
/// `SVGPrinter` is the core rendering engine of the swift-svg library.
/// It maintains the state needed during the rendering process, including
/// attributes, bytes buffer, and transformation information. It also handles
/// formatting concerns like indentation and newlines.
///
/// Example:
/// ```swift
/// let icon = circle(cx: 50, cy: 50, r: 40) { fill("red") }
/// var printer = SVGPrinter(.pretty)
/// SVG._render(icon, into: &printer)
/// let bytes = printer.bytes
/// ```
///
/// Most users will not interact with `SVGPrinter` directly, but instead
/// use the `render()` method on SVG elements or documents.
public struct SVGPrinter: Sendable {

  /// The buffer of bytes representing the rendered SVG.
  public var bytes: ContiguousArray<UInt8> = []

  /// The current set of attributes to apply to the next SVG element.
  public var attributes: OrderedDictionary<String, String> = [:]

  /// Configuration for rendering, including formatting options.
  let configuration: Configuration

  /// The current indentation level for pretty-printing.
  public var currentIndentation = ""

  /// Creates a new SVG printer with the specified configuration.
  ///
  /// - Parameter configuration: The configuration to use for rendering.
  ///   Default is no indentation or newlines.
  public init(_ configuration: Configuration = .default) {
    self.configuration = configuration
  }
}

extension SVGPrinter {
  /// Configuration options for SVG rendering.
  public struct Configuration: Sendable {
    /// The indentation string to use for pretty-printing.
    public var indentation: String

    /// The newline string to use for pretty-printing.
    public var newline: String

    /// Creates a new configuration with the specified options.
    ///
    /// - Parameters:
    ///   - indentation: The indentation string.
    ///   - newline: The newline string.
    public init(indentation: String = "", newline: String = "") {
      self.indentation = indentation
      self.newline = newline
    }

    /// Default configuration with no formatting.
    public static let `default` = Configuration()

    /// Configuration for pretty-printed output.
    public static let pretty = Configuration(indentation: "  ", newline: "\n")
  }
}

extension SVGPrinter {
  /// Appends a string to the bytes buffer.
  public mutating func append(_ string: String) {
    bytes.append(contentsOf: string.utf8)
  }

  /// Appends a newline if configured for pretty printing.
  public mutating func appendNewlineIfNeeded() {
    if !configuration.newline.isEmpty {
      append(configuration.newline)
    }
  }

  /// Increases the indentation level.
  public mutating func indent() {
    currentIndentation += configuration.indentation
  }

  /// Decreases the indentation level.
  public mutating func outdent() {
    currentIndentation.removeLast(configuration.indentation.count)
  }

  /// Appends the current indentation if configured for pretty printing.
  public mutating func appendIndentationIfNeeded() {
    if !configuration.indentation.isEmpty && !currentIndentation.isEmpty {
      append(currentIndentation)
    }
  }
}

// MARK: - Render Extension

extension SVG {
  /// Renders this SVG element to a string.
  ///
  /// - Returns: The rendered SVG as a string.
  public func render() -> String {
    String(decoding: renderBytes(), as: UTF8.self)
  }

  /// Renders this SVG element to bytes.
  ///
  /// This method creates a printer with the current configuration and
  /// renders the SVG element into it, then returns the resulting bytes.
  ///
  /// - Returns: A buffer of bytes representing the rendered SVG.
  public func renderBytes() -> ContiguousArray<UInt8> {
    @Dependency(\.svgPrinter) var svgPrinter
    var printer = svgPrinter
    Self._render(self, into: &printer)
    return printer.bytes
  }

  /// Renders this SVG element to a string with a specific configuration.
  ///
  /// - Parameter configuration: The configuration to use for rendering.
  /// - Returns: The rendered SVG as a string.
  public func render(_ configuration: SVGPrinter.Configuration) -> String {
    String(decoding: renderBytes(configuration), as: UTF8.self)
  }

  /// Renders this SVG element to bytes with a specific configuration.
  ///
  /// - Parameter configuration: The configuration to use for rendering.
  /// - Returns: A buffer of bytes representing the rendered SVG.
  public func renderBytes(_ configuration: SVGPrinter.Configuration) -> ContiguousArray<UInt8> {
    var printer = SVGPrinter(configuration)
    Self._render(self, into: &printer)
    return printer.bytes
  }
}

// MARK: - Dependency

extension DependencyValues {
  /// The current SVG printer used for rendering.
  public var svgPrinter: SVGPrinter {
    get { self[SVGPrinterKey.self] }
    set { self[SVGPrinterKey.self] = newValue }
  }
}

private enum SVGPrinterKey: DependencyKey {
  static let liveValue = SVGPrinter()
  static let previewValue = SVGPrinter(.pretty)
  static let testValue = SVGPrinter(.default)
}
