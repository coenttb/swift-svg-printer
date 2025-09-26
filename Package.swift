// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-svg-printer",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        .library(
            name: "SVGPrinter",
            targets: ["SVGPrinter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-svg-types", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SVGPrinter",
            dependencies: [
                .product(name: "SVGTypes", package: "swift-svg-types"),
                .product(name: "OrderedCollections", package: "swift-collections"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "SVGPrinterTests",
            dependencies: ["SVGPrinter"]
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("MemberImportVisibility"),
    .enableUpcomingFeature("StrictUnsafe"),
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
]

for index in package.targets.indices {
    package.targets[index].swiftSettings = (package.targets[index].swiftSettings ?? []) + swiftSettings
}
