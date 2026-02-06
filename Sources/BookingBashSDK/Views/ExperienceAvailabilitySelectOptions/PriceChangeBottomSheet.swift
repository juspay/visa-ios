//
//  PriceChangeBottomSheet.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 23/01/26.
//

import SwiftUI

struct PriceChangeBottomSheet: View {
    @Binding var isPresented: Bool
    var priceCheckData: PriceCheckModel?
    private var oldPriceData: PriceData? {
        priceCheckData?.oldPrice
    }
    private var newPriceData: PriceData? {
        priceCheckData?.currentPrice
    }
    var onContinueClick: (() -> Void)? = nil

    var body: some View {
        BottomSheetView(isPresented: $isPresented) {
            VStack(alignment: .center, spacing: 30) {
                if let changeValueImage = ImageLoader.bundleImage(named: Constants.Icons.wallet) {
                    changeValueImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 74, height: 70)
                        .padding(.top, 40)
                }
                
                VStack(alignment: .center, spacing: 16) {
                    Text("The price has changed from \(oldPriceData?.currency ?? currencyGlobal) \(oldPriceData?.totalAmount?.commaSeparated() ?? "0.00") to \(newPriceData?.currency ?? currencyGlobal) \(newPriceData?.totalAmount?.commaSeparated() ?? "0.00"). Please review and confirm before continuing.")
                        .font(.custom(Constants.Font.openSansBold, size: 16))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                
                Button(action: {
                    onContinueClick?()
                }) {
                    Text("Continue")
                        .font(.custom(Constants.Font.openSansBold, size: 12))
                        .foregroundStyle(.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 22)
                        .background(Color(hex: Constants.HexColors.primary))
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .padding(.top, 10)
                .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
//    PriceChangeBottomSheet(isPresented: .constant(true), changedValue: "550", changeType: "increased")
}
