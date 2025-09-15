//
//  CancelBookingBottomSheet.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import Foundation
import SwiftUI

struct CancelBookingBottomSheetView: View {
    @ObservedObject var viewModel: ExperienceBookingConfirmationViewModel
    @Binding var cancellationSheetState: CancellationSheetState
    
    @State private var isCancelling: Bool = false
    @State private var cancelError: String? = nil
    @State private var isFetchingReasons: Bool = false
    @State private var fetchReasonsError: String? = nil
    
    var onCancelled: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Show loading state for reasons fetching
            if isFetchingReasons {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading cancellation reasons...")
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
                .padding(.vertical, 8)
            } else if let fetchError = fetchReasonsError {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Failed to load cancellation reasons: \(fetchError)")
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(.red)
                    Button("Retry") {
                        fetchReasonsError = nil
                        isFetchingReasons = true
                        let orderNo = viewModel.bookingBasicDetails.first(where: { $0.key == "Booking ID" })?.value ?? ""
                        viewModel.fetchCancellationReasons(orderNo: orderNo) {
                            isFetchingReasons = false
                            if let error = viewModel.errorMessage, !error.isEmpty {
                                fetchReasonsError = error
                            }
                        }
                    }
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
                .padding(.vertical, 8)
            } else if viewModel.reasons.isEmpty {
                Text("No cancellation reasons available")
                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    .padding(.vertical, 8)
            } else {
                // Show reason selection
                VStack(alignment: .leading, spacing: 8) {
                    Text(Constants.BookingStatusScreenConstants.selectCancellationReason)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    
                    ForEach(viewModel.reasons, id: \.code) { reason in
                        Button(action: {
                            viewModel.selectedReason = reason
                        }) {
                            HStack {
                                Image(systemName: viewModel.selectedReason?.code == reason.code ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(viewModel.selectedReason?.code == reason.code ? Color(hex: Constants.HexColors.primary) : Color(hex: Constants.HexColors.neutral))
                                Text(reason.title)
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                                Spacer()
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.vertical, 8)
            }
            
            Button(action: {
                guard let selectedReason = viewModel.selectedReason else { return }
                isCancelling = true
                cancelError = nil
                let orderNo = viewModel.bookingBasicDetails.first(where: { $0.key == "Booking ID" })?.value ?? ""
                viewModel.cancelBooking(orderNoo: orderNo, siteId: "68b585760e65320801973737", reasonCode: selectedReason.code) { success in
                    isCancelling = false
                    if success {
                        cancellationSheetState = .none
                        onCancelled?()
                    } else {
                        cancelError = viewModel.errorMessage ?? "Failed to cancel booking."
                    }
                }
            }) {
                if isCancelling {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                } else {
                    Text(Constants.BookingStatusScreenConstants.cancelNow)
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
            }
            .padding(.top, 8)
            .disabled(isCancelling || viewModel.selectedReason == nil)
            if let error = cancelError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 4)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .onAppear {
            isFetchingReasons = true
            let orderNo = viewModel.bookingBasicDetails.first(where: { $0.key == "Booking ID" })?.value ?? ""
            viewModel.fetchCancellationReasons(orderNo: orderNo) {
                isFetchingReasons = false
                if let error = viewModel.errorMessage, !error.isEmpty {
                    fetchReasonsError = error
                }
            }
        }
    }
}
