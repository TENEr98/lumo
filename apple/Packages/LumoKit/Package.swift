// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LumoKit",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(name: "LumoKit", targets: ["LumoKit"]),
    ],
    targets: [
        // Rust-ядро; собирается scripts/build-xcframework.sh, в git не хранится.
        .binaryTarget(name: "LumoCoreFFI", path: "../../Frameworks/LumoCoreFFI.xcframework"),
        // Сгенерированные UniFFI-привязки. Не править вручную.
        .target(
            name: "LumoCore",
            dependencies: ["LumoCoreFFI"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(name: "LumoKit", dependencies: ["LumoCore"]),
        .testTarget(name: "LumoKitTests", dependencies: ["LumoKit"]),
    ]
)
