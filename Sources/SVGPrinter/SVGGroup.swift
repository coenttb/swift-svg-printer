//
//  SVGGroup.swift
//  swift-svg
//
//  Created by Coen ten Thije Boonkkamp
//

/// A container that groups multiple SVG elements together.
///
/// `SVGGroup` allows you to compose multiple SVG elements without
/// adding any additional rendering structure. It's useful for
/// returning multiple elements from computed properties or functions.
///
/// Example:
/// ```swift
/// var icons: some SVG {
///     SVGGroup {
///         circle(cx: 10, cy: 10, r: 5)
///         rect(x: 20, y: 20, width: 10, height: 10)
///     }
/// }
/// ```
public struct SVGGroup<Content: SVG>: SVG {
    /// The content of the group.
    let content: Content

    /// Creates a group with the given content.
    ///
    /// - Parameter content: A closure that returns the SVG content.
    public init(@SVGBuilder _ content: () -> Content) {
        self.content = content()
    }

    /// The body of the group is its content.
    public var body: some SVG {
        content
    }
}