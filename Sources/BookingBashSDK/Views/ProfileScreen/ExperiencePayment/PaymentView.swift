import SwiftUI

struct PaymentView: View {
    var orderId: String
    var paymentUrl: String
    var participantsSummary: String
    var selectedTime: String? // <-- Add selectedTime
    @State private var shouldNavigateToConfirmation = false

    var body: some View {
        ZStack {
            ThemeTemplateView(needsScroll: false,
                header: {
                    HStack(spacing: 8) {
                        Image(systemName: "creditcard")
                            .foregroundColor(.white)
                        Text(Constants.ExperiencePaymentConstants.payment)
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    .padding(.top, 8)
                },
                content: {
                    PaymentWebView(
                        orderId: orderId,
                        paymentUrl: paymentUrl,
                        shouldNavigateToConfirmation: $shouldNavigateToConfirmation
                    )
                    .edgesIgnoringSafeArea(.bottom)
                }
            )
            .navigationBarBackButtonHidden(true)
            
            NavigationLink(isActive: $shouldNavigateToConfirmation) {
                ExperienceBookingConfirmationView(orderNo: orderId, participantsSummary: participantsSummary, selectedTime: selectedTime)
                    .navigationBarBackButtonHidden(true)
            } label: { EmptyView() }
        }
    }
}
