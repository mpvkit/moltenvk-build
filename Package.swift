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
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.2.8/MoltenVK.xcframework.zip",
            checksum: "2cd44256bf36339059f93847ec3be3d7547f746584f2bbd80bc4216d1d306e36"
        )
    ]
)
