//
//  ExperienceExitView.swift
//  VisaActivity
//
//  Created by Apple on 08/08/25.
//

import SwiftUI

struct ExperienceExitView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(Constants.Icons.activity)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
            Text(Constants.HomeScreenConstants.cancelBookingText)
                .font(.custom(Constants.Font.openSansBold, size: 16))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            
            HStack(spacing: 20) {
                ExitButtonsView(
                    buttonText: Constants.HomeScreenConstants.skip,
                    backgroundColor: Color.white,
                    buttontapped: {
                        
                    })
                
                ExitButtonsView(
                    textColor: Color.white,
                    buttonText: Constants.HomeScreenConstants.stay,
                    buttontapped: {
                        
                    })
            }
        }
    }
}

#Preview {
    ExperienceExitView()
}
