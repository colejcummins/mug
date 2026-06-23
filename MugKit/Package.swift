// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MugKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "MugKit", targets: ["MugKit"]),
    ],
    targets: [
        .target(name: "MugKit"),
        .testTarget(name: "MugKitTests", dependencies: ["MugKit"]),
    ]
)
