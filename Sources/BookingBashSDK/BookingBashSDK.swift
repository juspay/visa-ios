import SwiftUI
import SUINavigation

@objc public class BookingBashSDK: NSObject {

    @objc public static func createExperienceHomeView(encryptPayLoad: String, callback: @escaping () -> Void, environment: String) -> UIViewController {
        let view =
            if #available(iOS 16.0, *) {
                AnyView(
                    NavigationStack {
                        ExperienceHomeView(
                            encryptPayLoadMainapp: encryptPayLoad,
                            isActive: .constant(true),
                            onFinish:callback,
                            environment: environment
                        )
                        .preferredColorScheme(.light)
                    }
                )
            } else {
                AnyView(
                    NavigationStorageView {
                        ExperienceHomeView(
                            encryptPayLoadMainapp: encryptPayLoad,
                            isActive: .constant(true),
                            onFinish: callback,
                            environment: environment
                        )
                        .preferredColorScheme(.light)
                    }
                )
            }
        let vc = UIHostingController.init(rootView: view);
        vc.overrideUserInterfaceStyle = .light;
        return vc;
    }
}
