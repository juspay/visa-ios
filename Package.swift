// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "VisaBenefitsSDK",
    platforms: [
        .iOS(.v12)
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
        .package(url: "https://github.com/sindresorhus/SUINavigation.git", from: "1.0.0"),
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
            path: "Sources/BookingBashSDK"
        )
    ]
)