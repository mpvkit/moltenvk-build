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
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.4.2/MoltenVK.xcframework.zip",
            checksum: "aee189c54ad7c62bf734a3dc51eb4cfad5685d1d63b0ec519ecd1b437c332418"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
