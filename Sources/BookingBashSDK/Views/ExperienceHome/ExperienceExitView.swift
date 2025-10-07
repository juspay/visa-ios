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
            if let activityImage = bundleImage(named: Constants.Icons.activity) {
                activityImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
            
            Text("Thank you for choosing Visa")
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(Color(hex: Constants.HexColors.secondary))
                .multilineTextAlignment(.center)
            
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
