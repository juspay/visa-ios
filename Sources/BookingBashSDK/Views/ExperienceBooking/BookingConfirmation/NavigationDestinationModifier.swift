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
                }
        } else {
            content
                .background(
                    NavigationLink(
                        destination: HomeDestinationWrapperView(),
                        isActive: $navigateToHome
                    ) {
                        EmptyView()
                    }
                )
        }
    }
}

struct HomeDestinationWrapperView: View {
    @State private var isHomeActive = true
    
    var body: some View {
        ExperienceHomeView(
            encryptPayLoadMainapp: encryptedPayload,
            isActive: $isHomeActive,
            onFinish: globalOnFinishCallback
        )
        .onAppear {
            print("🟢 HomeDestinationWrapperView appeared - user returned from booking confirmation")
            // Removed auto-trigger - let user interact with home page normally
            // The onFinish callback will be triggered when user taps back button
        }
    }
}
