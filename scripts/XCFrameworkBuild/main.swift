import Foundation

do {
    try Build.performCommand(arguments: Array(CommandLine.arguments.dropFirst()))


    try BuildVulkan().buildALL()
} catch {
    print(error.localizedDescription)
    exit(1)
}


enum Library: String, CaseIterable {
    case vulkan
    var version: String {
        switch self {
        case .vulkan:
            return "v1.2.9"
        }
    }

    var url: String {
        switch self {
        case .vulkan:
            return "https://github.com/KhronosGroup/MoltenVK"
        }
    }
}



private class BuildVulkan: BaseBuild {
    init() {
        super.init(library: .vulkan)

        // // switch to main branch to pull newest code
        // try! Utility.launch(path: "/usr/bin/git", arguments: ["remote", "set-branches", "--add", "origin", "main"], currentDirectoryURL: directoryURL)
        // try! Utility.launch(path: "/usr/bin/git", arguments: ["fetch", "origin", "main:main"], currentDirectoryURL: directoryURL)
        // try! Utility.launch(path: "/usr/bin/git", arguments: ["checkout", "main"], currentDirectoryURL: directoryURL)
    }

    override func buildALL() throws {
        // pull dependencies code
        let arguments = platforms().map {
            "--\($0.name)"
        }
        try Utility.launch(path: (directoryURL + "fetchDependencies").path, arguments: arguments, currentDirectoryURL: directoryURL)

        // clean old release files
        let releaseDirPath = URL.currentDirectory + ["release"]
        try? FileManager.default.removeItem(at: releaseDirPath)
        try? FileManager.default.createDirectory(at: releaseDirPath, withIntermediateDirectories: true, attributes: nil)

        // Generate xcframework for all platforms
        try buildXCFramework(name: "MoltenVK", platforms: platforms())


        // Generate xcframework for different platforms
        if BaseBuild.splitPlatform {
            var platforms = self.platforms()
            if platforms.contains(.ios) {
                var arguments : [PlatformType] = [.ios]
                platforms.removeAll(where: { $0 == .ios } )
                if platforms.contains(.isimulator) {
                    arguments += [.isimulator]
                    platforms.removeAll(where: { $0 == .isimulator } )
                }
                try buildXCFramework(name: "MoltenVK-ios", platforms: arguments)
            }
            if platforms.contains(.tvos) {
                var arguments : [PlatformType] = [.tvos]
                platforms.removeAll(where: { $0 == .tvos } )
                if platforms.contains(.tvsimulator) {
                    arguments += [.tvsimulator]
                    platforms.removeAll(where: { $0 == .tvsimulator } )
                }
                try buildXCFramework(name: "MoltenVK-tvos", platforms: arguments)
            }
            for platform in platforms {
                try buildXCFramework(name: "MoltenVK-\(platform.rawValue)", platforms: [platform])
            }
        }
    }

    private func buildXCFramework(name: String, platforms: [PlatformType]) throws {
        let arguments = platforms.map(\.name)
        try Utility.launch(path: "/usr/bin/make", arguments: ["clean"], currentDirectoryURL: directoryURL)
        try Utility.launch(path: "/usr/bin/make", arguments: arguments, currentDirectoryURL: directoryURL)


        // package release
        let releaseDirPath = URL.currentDirectory + ["release"]
        let XCFrameworkFile = "MoltenVK.xcframework"
        let zipFile = releaseDirPath + [name + ".xcframework.zip"]
        let checksumFile = releaseDirPath + [name + ".xcframework.checksum.txt"]
        try Utility.launch(path: "/usr/bin/zip", arguments: ["-qr", zipFile.path, XCFrameworkFile], currentDirectoryURL: directoryURL + "Package/Release/MoltenVK/static/")
        Utility.shell("swift package compute-checksum \(zipFile.path) > \(checksumFile.path)")
    }
}
