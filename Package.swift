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
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.4.0/MoltenVK.xcframework.zip",
            checksum: "81aa59540c563e17558238e9475166a4b29c4119878e216d2de42ca9315bcc40"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
