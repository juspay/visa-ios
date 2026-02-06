import SwiftUI
import SUINavigation

struct NavigationDestinationModifier: ViewModifier {
    @Binding var navigateToHome: Bool
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationDestination(isPresented: $navigateToHome) {
                    HomeDestinationWrapperView()
                        .navigationBarBackButtonHidden(true)
                }
        } else {
            content
                .navigation(
                    isActive: $navigateToHome,
                    id: "home_navigation"
                ) {
                    HomeDestinationWrapperView()
                }
        }
    }
}

struct HomeDestinationWrapperView: View {
    @State private var isHomeActive = true
    
    var body: some View {
        ExperienceHomeView(
            encryptPayLoadMainapp: encryptedPayloadMain,
            isActive: $isHomeActive,
            onFinish: globalOnFinishCallback,
            environment: environmentType
        )
        
    }
}
