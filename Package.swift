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
            url: "https://github.com/mpvkit/moltenvk-build/releases/download/1.2.11/MoltenVK.xcframework.zip",
            checksum: "903b476d4d89d35ed0ce413f7514f54e3d8db9f3e7bd126896f74d07fa4134a1"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)
