// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-svg-printer",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(
            name: "SVGPrinter",
            targets: ["SVGPrinter"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-svg-standard.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SVGPrinter",
            dependencies: [
                .product(name: "SVG Standard", package: "swift-svg-standard"),
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "SVGPrinterTests",
            dependencies: ["SVGPrinter"]
        )
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault")
]

for index in package.targets.indices {
    package.targets[index].swiftSettings = (package.targets[index].swiftSettings ?? []) + swiftSettings
}
