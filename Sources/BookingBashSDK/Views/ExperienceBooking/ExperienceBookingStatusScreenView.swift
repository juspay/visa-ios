//
//  ExperienceBookingStatusScreenView.swift
//  VisaActivity
//
//  Created by Apple on 07/08/25.
//

import Foundation
import SwiftUI

enum BookingStatus {
    case confirmed
    case bookingPending
    case paymentfailed
    case bookingFailed
    case cancelled
}

struct ExperienceBookingStatusScreenView: View {
    @StateObject private var viewModel = ExperienceBookingConfirmationViewModel()

    var body: some View {
        VStack(spacing: 16) {
            switch viewModel.bookingStatus {
            case .confirmed:
                ExperienceBookingConfirmationView(orderNo: viewModel.bookingRef ?? "")

            case .bookingPending:
                BookingPendingView(experienceBookingConfirmationViewModel: viewModel, participantsSummary: viewModel.participantsSummary)

            case .paymentfailed:
                PaymentFailedView(experienceBookingConfirmationViewModel: viewModel, participantsSummary: viewModel.participantsSummary)

            case .bookingFailed:
                BookingFailedView(experienceBookingConfirmationViewModel: viewModel, participantsSummary: viewModel.participantsSummary)
                
            case .cancelled:
                BookingCancellationView(experienceBookingConfirmationViewModel: viewModel, participantsSummary: viewModel.participantsSummary)
            }
        }
    }
}
