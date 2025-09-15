import SwiftUI

struct NavigationDestinationModifier: ViewModifier {
    @Binding var navigateToHome: Bool
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationDestination(isPresented: $navigateToHome) {
                    LaunchPageView() // Pass actual payload if needed
                }
        } else {
            content
        }
    }
}
