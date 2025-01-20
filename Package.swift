// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "FakePreview",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "FakePreview",
            targets: ["FakePreview"]
        ),
        .executable(
            name: "FakePreviewClient",
            targets: ["FakePreviewClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "FakePreviewMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "FakePreview", dependencies: ["FakePreviewMacros"]),
        .executableTarget(name: "FakePreviewClient", dependencies: ["FakePreview"]),
        .testTarget(
            name: "FakePreviewTests",
            dependencies: [
                "FakePreviewMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
