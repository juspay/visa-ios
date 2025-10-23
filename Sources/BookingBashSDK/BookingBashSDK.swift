import SwiftUI
import SUINavigation

@objc public class BookingBashSDK: NSObject {

    @objc public static func createExperienceHomeView(encryptPayLoad: String, callback: @escaping () -> Void) -> UIViewController {
        let view = NavigationStorageView {
            ExperienceHomeView(
                encryptPayLoadMainapp: encryptPayLoad,
                isActive: .constant(true),
                onFinish: callback
            )
        }
        return UIHostingController.init(rootView: view)
    }

}
