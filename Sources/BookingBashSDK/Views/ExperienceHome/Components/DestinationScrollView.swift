//
//  DestinationScrollView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct DestinationScrollView: View {
    let destinations: [Destination]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(destinations) { destination in
                    DestinationCardView(destination: destination)
                    
                }
            }
            .padding(.leading, 15)
        }
    }
}

