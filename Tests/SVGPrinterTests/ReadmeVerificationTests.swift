//
//  ReadmeVerificationTests.swift
//  swift-svg-printer
//
//  Created by Coen ten Thije Boonkkamp
//

import Testing
import SVGPrinter
import OrderedCollections

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test("Quick Start example (README lines 38-52)")
    func quickStartExample() throws {
        // From README Quick Start section
        // Create a printer
        var printer = SVGPrinter()

        // Build SVG markup
        printer.append("<circle cx=\"50\" cy=\"50\" r=\"40\"/>")

        // Get result as string
        let svgString = String(decoding: printer.bytes, as: UTF8.self)
        // Output: <circle cx="50" cy="50" r="40"/>
        #expect(svgString == "<circle cx=\"50\" cy=\"50\" r=\"40\"/>")
    }

    @Test("Pretty Printing example (README lines 54-72)")
    func prettyPrintingExample() throws {
        // From README Pretty Printing section
        var printer = SVGPrinter(.pretty)
        printer.append("<svg>")
        printer.appendNewlineIfNeeded()
        printer.indent()
        printer.appendIndentationIfNeeded()
        printer.append("<circle cx=\"50\" cy=\"50\" r=\"40\"/>")
        printer.outdent()
        printer.appendNewlineIfNeeded()
        printer.append("</svg>")

        let output = String(decoding: printer.bytes, as: UTF8.self)
        #expect(output.contains("<svg>"))
        #expect(output.contains("\n"))
        #expect(output.contains("  ")) // indentation
        #expect(output.contains("<circle"))
    }

    @Test("Attribute Management example (README lines 74-86)")
    func attributeManagementExample() throws {
        // From README Attribute Management section
        var printer = SVGPrinter()
        printer.attributes["fill"] = "red"
        printer.attributes["stroke"] = "black"

        // Attributes can be accessed and managed
        let fillColor = printer.attributes["fill"] // "red"
        #expect(fillColor == "red")
        #expect(printer.attributes["stroke"] == "black")
    }
}
