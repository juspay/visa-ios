import SwiftUI

extension View {
    func navigation<Destination: View>(
        isActive: Binding<Bool>,
        id: String,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View {
        if #available(iOS 16.0, *) {
            AnyView(
                self.navigationDestination(isPresented: isActive) {
                    destination()
                }
            )
        } else {
            AnyView(
                self.background(
                    NavigationLink(
                        destination: destination(),
                        isActive: isActive
                    ) {
                        EmptyView()
                    }
                    .hidden()
                )
            )
        }
    }
}
