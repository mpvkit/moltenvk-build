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
            checksum: "1821c9338489735b4526c5176cd8e4e3f1653ae720407759737a07f3d78e7878"
        )
    ]
)
