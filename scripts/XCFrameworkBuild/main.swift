import Foundation

do {
    let options = try ArgumentOptions.parse(CommandLine.arguments)
    try Build.performCommand(options)

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
        try packageAllRelease()

        // Generate xcframework for different platforms
        if BaseBuild.options.enableSplitPlatform {
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

    private func packageAllRelease() throws {
        let releaseDirPath = URL.currentDirectory + ["release"]
        let releaseLibPath = releaseDirPath + [library.rawValue]
        try? FileManager.default.removeItem(at: releaseLibPath)
        try? FileManager.default.createDirectory(at: releaseLibPath, withIntermediateDirectories: true, attributes: nil)


        // copy includes
        let includePath =  directoryURL + "Package/Release/MoltenVK/include"
        let destIncludePath = releaseLibPath + ["include"]
        try FileManager.default.copyItem(at: includePath, to: destIncludePath)

        // generate pkg-config file example
        for platform in platforms() {
            var frameworks = ["CoreFoundation", "CoreGraphics", "Foundation", "IOSurface", "Metal", "QuartzCore"]
            if platform == .macos {
                frameworks.append("Cocoa")
            } 
            if platform != .macos {
                frameworks.append("UIKit")
            }
            if !(platform == .tvos || platform == .tvsimulator) {
                frameworks.append("IOKit")
            }
            let libframework = frameworks.map {
                "-framework \($0)"
            }.joined(separator: " ")
            for arch in architectures(platform) {
                let content = """
                prefix=/path/to/workdir/\(library.rawValue)/\(platform.rawValue)/thin/\(arch.rawValue)
                includedir=${prefix}/include
                libdir=${prefix}/lib

                Name: Vulkan-Loader
                Description: Vulkan Loader
                Version: \(self.library.version)
                Libs: -L${libdir} -lMoltenVK \(libframework)
                Cflags: -I${includedir}
                """
                let destPkgConfigPath = releaseLibPath + ["pkgconfig-example", platform.rawValue, arch.rawValue]
                try? FileManager.default.createDirectory(at: destPkgConfigPath, withIntermediateDirectories: true, attributes: nil)

                let vulkanPC = destPkgConfigPath +  "MoltenVK.pc"
                FileManager.default.createFile(atPath: vulkanPC.path, contents: content.data(using: .utf8), attributes: nil)
            }
        }

        // copy xcframeworks
        let xcframeworks = directoryURL + "Package/Release/MoltenVK/static/MoltenVK.xcframework"
        let destLibPath = releaseLibPath + ["lib"]
        try? FileManager.default.createDirectory(at: destLibPath, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.copyItem(at: xcframeworks, to: destLibPath + "MoltenVK.xcframework")


        // zip all
        let destZipLibPath = releaseDirPath + ["MoltenVK-all.zip"]
        try? FileManager.default.removeItem(at: destZipLibPath)
        try Utility.launch(path: "/usr/bin/zip", arguments: ["-qr", destZipLibPath.path, "./"], currentDirectoryURL: releaseLibPath)
    }

}
