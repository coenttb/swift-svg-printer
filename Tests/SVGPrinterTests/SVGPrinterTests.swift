//
//  SVGPrinterTests.swift
//  swift-svg-printer
//
//  Created by Coen ten Thije Boonkkamp
//

import OrderedCollections
import SVGPrinter
import SVGTypes
import Testing

@Suite("SVG Printer Tests")
struct SVGPrinterTests {

  @Test("Basic printer functionality")
  func basicPrinter() {
    var printer = SVGPrinter()
    printer.append("<test>")
    printer.append("content")
    printer.append("</test>")

    let result = String(decoding: printer.bytes, as: UTF8.self)
    #expect(result == "<test>content</test>")
  }

  @Test("Pretty printing")
  func prettyPrinting() {
    var printer = SVGPrinter(.pretty)
    printer.append("<parent>")
    printer.appendNewlineIfNeeded()
    printer.indent()
    printer.appendIndentationIfNeeded()
    printer.append("<child />")
    printer.outdent()
    printer.appendNewlineIfNeeded()
    printer.append("</parent>")

    let result = String(decoding: printer.bytes, as: UTF8.self)
    #expect(result.contains("\n"))
    #expect(result.contains("  "))  // indentation
  }

  @Test("Attribute collection")
  func attributes() {
    var printer = SVGPrinter()
    printer.attributes["fill"] = "red"
    printer.attributes["stroke"] = "black"

    #expect(printer.attributes["fill"] == "red")
    #expect(printer.attributes["stroke"] == "black")
  }
}
