import SwiftUI
import SUINavigation

public struct BookingBashSDK {
    public init() {}

    public static func createExperienceHomeView(encryptPayLoad: String) -> some View {
        ExperienceHomeWrapper(encryptPayLoad: encryptPayLoad)
    }
    
    public static func createMyTransactionView() -> some View {
        MyTransactionView()
    }
}

private struct ExperienceHomeWrapper: View {
    let encryptPayLoad: String
    @State private var isActive = true

    var body: some View {
        ExperienceHomeView(
            encryptPayLoad: encryptPayLoad,
            isActive: $isActive,
            onFinish: {
                print("Got callback")
            }
        )
    }
}