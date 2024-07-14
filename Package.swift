// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "moltenvk",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(
            name: "MoltenVK", 
            targets: ["_MoltenVK"]
        ),
    ],
    targets: [
        // Need a dummy target to embedded correctly.
        // https://github.com/apple/swift-package-manager/issues/6069
        .target(
            name: "_MoltenVK",
            dependencies: ["MoltenVK"],
            path: "Sources/_Dummy"
        ),
        //AUTO_GENERATE_TARGETS_BEGIN//

        .binaryTarget(
            name: "MoltenVK",
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.2.9/MoltenVK.xcframework.zip",
            checksum: "02dd7f51814855b7db9eacd883042b3e9481eb658de6bc63290af80149f2b94f"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
