// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Coolness",
    products: [
        .library(
            name: "Coolness",
            targets: ["Coolness"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Coolness",
            dependencies: [],
            // asset catalogs are processed automatically,
            // but for a single file you have to say what to do with it
            resources: [.process("jack.jpg")]
        )
    ]
)
