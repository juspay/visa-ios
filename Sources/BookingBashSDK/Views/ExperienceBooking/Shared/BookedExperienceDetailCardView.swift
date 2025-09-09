//
//  BookedExperienceDetailCardView.swift
//  VisaActivity
//
//  Created by Apple on 06/08/25.
//

import SwiftUI

struct BookedExperienceDetailCardView: View {
    @ObservedObject var experienceViewModel: ExperienceAvailabilitySelectOptionsViewModel
    @ObservedObject var confirmationViewModel: ExperienceBookingConfirmationViewModel
    let viewDetailsButtonTapped: (() -> Void)?
    let cancelBookingButtonTapped: (() -> Void)?
    var isBookingConfirmationScreen: Bool = true
    @Binding var shouldExpandDetails: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ExperienceDetailsCardHeaderView(
                images: [
                    Constants.Icons.print,
                    Constants.Icons.download,
                    Constants.Icons.Share]
            )
            BookedExperienceDetailInfoTopLocationView(
                title: confirmationViewModel.title ?? packageTitleG,
                location: confirmationViewModel.location ?? addressG,
                titleTextColor: Color(hex: Constants.HexColors.blackStrong),
                locationTextColor: Color(hex: Constants.HexColors.neutral)
            )
            BookedExperienceDateTimeView(color: Color(hex: Constants.HexColors.neutral), checkInDate: checkInDateG)
            if(isBookingConfirmationScreen) {
                AddItineraryButtonView()
                HStack(spacing: 2) {
                    Text(Constants.BookingStatusScreenConstants.forSupplierVoucher)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    Button(action: {
                        
                    }, label: {
                        Text(Constants.BookingStatusScreenConstants.clickHere)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    })
                }
            }
            if(!shouldExpandDetails) {
                HStack(spacing: 16) {
                    ActionButton(title: Constants.BookingStatusScreenConstants.viewDetails) {
                        viewDetailsButtonTapped?()
                    }
                    if(isBookingConfirmationScreen) {
                        ActionButton(title: Constants.BookingStatusScreenConstants.cancelBooking) {
                            cancelBookingButtonTapped?()
                        }
                    }
                }
                .padding(.top, 12)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: Constants.HexColors.neutralWeak), lineWidth: 1)
        )
    }
}
