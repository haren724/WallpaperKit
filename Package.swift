// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WallpaperKit",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WallpaperKit",
            targets: ["WallpaperKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WallpaperKit",
            cSettings: [.define("GL_SILENCE_DEPRECATION")],
            cxxSettings: [.define("GL_SILENCE_DEPRECATION")],
            swiftSettings: [.define("GL_SILENCE_DEPRECATION")]),
        .target(
            name: "Common", dependencies: ["WallpaperKit"], path: "Tests/Common"),
//        .systemLibrary(
//                name: "Cglew",
//                pkgConfig: "glew",
//                providers: [
//                    .brew(["glew"])
//                ]),
        .systemLibrary(
                name: "Cglfw",
                pkgConfig: "glfw3",
                providers: [
                    .brew(["glfw"]),
                ]),
        .systemLibrary(
                name: "Cglew",
                pkgConfig: "glew",
                providers: [
                    .brew(["glew"]),
                ]),
        .systemLibrary(
                name: "Cglm",
                pkgConfig: "glm",
                providers: [
                    .brew(["glew"]),
                ]),
        .target(
            name: "GLFWBridge",
            dependencies: ["Cglfw"],
            linkerSettings: [
                .linkedFramework("OpenGL"),
            ]),
        .testTarget(
            name: "WallpaperKitTests",
            dependencies: ["WallpaperKit", "Common"],
            resources: []),
        .testTarget(
            name: "VideoWallpaperTests",
            dependencies: ["WallpaperKit", "Common"],
            resources: [
                .process("Resources"),
            ]),
        .testTarget(
            name: "WebWallpaperTests",
            dependencies: ["WallpaperKit", "Common"],
            resources: [
                .process("Resources"),
            ]),
        .testTarget(
            name: "SceneWallpaperTests",
            dependencies: ["WallpaperKit", "Common", "GLFWBridge", "Cglfw", "Cglew", "Cglm"],
            resources: [
                .process("Resources"),
            ],
            cSettings: [.define("GL_SILENCE_DEPRECATION")],
            cxxSettings: [.define("GL_SILENCE_DEPRECATION")],
            swiftSettings: [.interoperabilityMode(.Cxx), .define("GL_SILENCE_DEPRECATION")]),
        
    ]
)
