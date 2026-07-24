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
            checksum: "99650150c2c192c46fe55844437debe86901922f2899e75afbeb2eb9e3cd5ae9"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
