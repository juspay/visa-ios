// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "VisaBenefitsSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "VisaBenefitsSDK",
            targets: ["VisaBenefitsSDK"]
        ),
        .library(
            name: "BookingBashSDK",
            targets: ["BookingBashSDK"]
        )
    ],
    dependencies: [
        .package(name: "HyperSDK", url: "https://github.com/juspay/hypersdk-ios.git", .exact("2.2.4")),
        .package(url: "https://github.com/ozontech/SUINavigation.git", from: "1.11.0"),
        .package(url: "https://github.com/siteline/swiftui-introspect.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "VisaBenefitsSDK",
            dependencies: [
                .product(name: "HyperSDK", package: "HyperSDK"),
                "BookingBashSDK"
            ],
            path: "Sources/VisaBenefitsSDK",
            publicHeadersPath: "."
        ),
        .target(
            name: "BookingBashSDK",
            dependencies: [
                .product(name: "SUINavigation", package: "SUINavigation")
            ],
            path: "Sources/BookingBashSDK",
            resources: [
                .process("Resources")
            ]
        )
    ]
)