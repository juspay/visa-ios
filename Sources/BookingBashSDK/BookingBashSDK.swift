import SwiftUI
import SUINavigation

@objc public class BookingBashSDK: NSObject {

    @objc public static func createExperienceHomeView(encryptPayLoad: String, callback: @escaping () -> Void) -> UIViewController {
        let view = ExperienceHomeWrapper(encryptPayLoad: encryptPayLoad, onFinish: callback)
        return UIHostingController(rootView: view)
    }

}

private struct ExperienceHomeWrapper: View {
    let encryptPayLoad: String
    let onFinish: () -> Void
    @State private var isActive = true

    var body: some View {
        NavigationStorageView {
            NavigationLink(
                destination: ExperienceHomeView(
                    encryptPayLoad: encryptPayLoad,
                    isActive: $isActive,
                    onFinish: onFinish
                ),
                isActive: $isActive
            ) {
                EmptyView()
            }
        }
    }
}
