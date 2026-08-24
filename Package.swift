// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "VisaBenefitsSDK",
    platforms: [
        .iOS("15.8.3")
    ],
    products: [
        .library(
            name: "VisaBenefitsSDK",
            targets: ["VisaBenefitsSDK"]
        )
    ],
    dependencies: [
        .package(name: "HyperSDK", url: "https://github.com/juspay/hypersdk-ios.git", .exact("2.2.9-visa.1")),
    ],
    targets: [
        .target(
            name: "VisaBenefitsSDK",
            dependencies: [
                .product(name: "HyperSDKCore", package: "HyperSDK")
            ],
            path: "Sources/VisaBenefitsSDK",
            publicHeadersPath: "."
        )
    ]
)
