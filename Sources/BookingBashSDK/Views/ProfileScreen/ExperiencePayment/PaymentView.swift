//
//  PaymentView.swift
//  VisaActivity
//
//  Created by Praveen on 05/09/25.
//

import SwiftUI

struct PaymentView: View {
    var orderId: String
    @Binding var shouldNavigateToConfirmation: Bool

    var body: some View {
        ThemeTemplateView(needsScroll: false,
            header: {
                HStack(spacing: 8) {
                    Image(systemName: "creditcard")
                        .foregroundColor(.white)
                    Text("Payment")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                .padding(.top, 8)
            },
            content: {
                VStack(spacing: 0) {
                    PaymentWebView(
                        orderId: orderId,
                        shouldNavigateToConfirmation: $shouldNavigateToConfirmation
                    )
                    .edgesIgnoringSafeArea(.bottom)

                    NavigationLink(
                        destination: ExperienceBookingConfirmationView(
//                            experienceBookingConfirmationViewModel: ExperienceBookingConfirmationViewModel(),
                            orderNo: orderId
                        ),
                        isActive: $shouldNavigateToConfirmation,
                        label: { EmptyView() }
                    )
                    .hidden()
                }
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}
