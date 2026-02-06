//
//  CancelBookingFailedBottomSheet.swift
//  VisaActivity
//
//  Created by Neosoft on 05/02/26.
//

import SwiftUI

struct CancelBookingFailedBottomSheet: View {
    @Binding var isPresented: Bool
    var onBackToHomeClick: () -> Void

    var body: some View {
        BottomSheetView(isPresented: $isPresented, dismissOnbackgroundClick: true) {
            VStack {
                VStack {
                    if let image = ImageLoader.bundleImage(named: Constants.CancelBookingBottomSheetConstants.unabelCancelImage) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }

                    VStack(spacing: 30) {
                        Text(Constants.CancelBookingBottomSheetConstants.cancelBookingFailedTitle)
                            .font(.custom(Constants.Font.openSansBold, size: 18))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .padding(.horizontal, 20)

                        Text(Constants.CancelBookingBottomSheetConstants.cancelBookingFailedDescription)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundColor(Color(hex: Constants.HexColors.neutral))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(nil)
                            .padding(.horizontal, 20)

                        contactDetailsCard

                        Button(action: {
                            isPresented = false
                            onBackToHomeClick()
                        }) {
                            Text(Constants.CancelBookingBottomSheetConstants.backToHome)
                                .font(.custom(Constants.Font.openSansBold, size: 12))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 42)
                                .background(Color(hex: Constants.HexColors.primary))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 10)
            }
        }
    }

    private var contactDetailsCard: some View {
        VStack(alignment: .leading, spacing: 5) {
        getContactDetailRoe(keyIcon: "Frame", value: "reservations@bookingbash.com")
            getContactDetailRoe(keyIcon: "mobile", value: "+97 148348696")
        }
    }

    private func getContactDetailRoe(keyIcon: String, value: String) -> some View  {
        HStack(spacing: 4) {
            if let icon = ImageLoader.bundleImage(named: keyIcon) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            } else {
                Image(keyIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            }
            Text(value)
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            Spacer()
        }
    }
}

#Preview {
    CancelBookingFailedBottomSheet(isPresented: .constant(true)) { }
}
