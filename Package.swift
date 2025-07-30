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
        )
    ],
    dependencies: [
        .package(name: "HyperSDK", url: "https://github.com/juspay/hypersdk-ios.git", .exact("2.2.4")),
    ],
    targets: [
        .target(
            name: "VisaBenefitsSDK",
            dependencies: [
                .product(name: "HyperSDK", package: "HyperSDK")
            ],
            path: "Sources/VisaBenefitsSDK",
            publicHeadersPath: "."
        )
    ]
)