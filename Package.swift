// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "moltenvk",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(
            name: "MoltenVK", 
            targets: ["MoltenVK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "MoltenVK",
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.2.9/MoltenVK.xcframework.zip",
            checksum: "47b52acb95f023a63b1d8fa0259613052dde4ac39187b5ffafa3c1e2bfd61bbb"
        )
    ]
)
