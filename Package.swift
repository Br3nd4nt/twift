// swift-tools-version:6.0
import PackageDescription

var packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.57.0")),
    .package(url: "https://github.com/nerzh/swift-telegram-bot", .upToNextMajor(from: "4.2.0")),
    .package(url: "https://github.com/apple/swift-testing.git", from: "0.9.0")
]

var targetDependencies: [PackageDescription.Target.Dependency] = [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "SwiftTelegramBot", package: "swift-telegram-bot")
]

var testingDependencies: [PackageDescription.Target.Dependency] = [
    .target(name: "twift"),
    .product(name: "Testing", package: "swift-testing") // Unable to find module dependency: '_TestingInternals'
]


let package = Package(
    name: "twift",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: packageDependencies,
    targets: [
        .executableTarget(
            name: "twift",
            dependencies: targetDependencies
        ),
        .testTarget(
            name: "twitterServiceTests",
            dependencies: testingDependencies
        )
    ]
)
