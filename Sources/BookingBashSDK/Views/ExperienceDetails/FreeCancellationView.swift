//
//  FreeCancellationView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct FreeCancellationView: View {
    let cancellationPolicy: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 4) {
                if let checkImage = ImageLoader.bundleImage(named: Constants.Icons.check) {
                    checkImage
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                        .padding(.top, 2)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(cancellationPolicy)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    
                    Text(Constants.DetailScreenConstants.viewCancellationPolicy)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.primary))
                }
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
