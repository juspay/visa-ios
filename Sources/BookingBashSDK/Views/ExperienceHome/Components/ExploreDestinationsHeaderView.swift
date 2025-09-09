//
//  ExploreDestinationsHeaderView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct ExploreDestinationsHeaderView: View {
    var body: some View {
        Text(Constants.HomeScreenConstants.exploreDestinations)
            .font(.custom(Constants.Font.openSansBold, size: 14))
            .foregroundStyle(Color.white)
    }
}

