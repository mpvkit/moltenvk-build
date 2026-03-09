// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "build",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "build", targets: ["build"])
    ],
    dependencies: [
        .package(url: "https://github.com/mpvkit/BuildShared.git", revision: "9c51172cc0fe59112866090f4f307f73c4bc27e3")
    ],
    targets: [
        .executableTarget(
            name: "build",
            dependencies: ["BuildShared"],
            path: "XCFrameworkBuild",
            sources: ["main.swift"]
        )
    ]
)
