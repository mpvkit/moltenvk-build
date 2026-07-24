// swift-tools-version:5.8

import PackageDescription

// Template consumed by BuildShared-based build scripts for release Package.swift generation.
let package = Package(
    name: "moltenvk",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15)],
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
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.4.1-fix/MoltenVK.xcframework.zip",
            checksum: "19e406c0a79fd74b7f7c20d5dcb1d9103a240389f90f3db49a3e1aef06176d2a"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
