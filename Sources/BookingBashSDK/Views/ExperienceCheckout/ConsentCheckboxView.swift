//
//  ConsentCheckboxView.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import SwiftUI

struct CheckboxTermsView: View {
    @Binding var isAgreed: Bool
    let termsAndConditionTapped: () -> Void
    let privacyPolicytapped: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button(action: {
                isAgreed.toggle()
            }){
                
                if let icon = bundleImage(named: isAgreed ? Constants.Icons.checkBoxFilled : Constants.Icons.checkBox) {
                    icon
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(
                            isAgreed
                            ? Color(hex: Constants.HexColors.primary)
                            : Color(hex: Constants.HexColors.neutral)
                        )
                } else {
                    Image(isAgreed ? Constants.Icons.checkBoxFilled : Constants.Icons.checkBox)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(
                            isAgreed
                            ? Color(hex: Constants.HexColors.primary)
                            : Color(hex: Constants.HexColors.neutral)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(Constants.CheckoutPageConstants.agree)
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    
                    Button(action: {
                        termsAndConditionTapped()
                    }) {
                        Text(Constants.CheckoutPageConstants.termsConditions)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text(Constants.CheckoutPageConstants.andText)
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                
                Button(action: {
                    privacyPolicytapped()
                }) {
                    Text(Constants.CheckoutPageConstants.privacyPolicy)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()
        }
    }
}
