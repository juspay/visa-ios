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
    let onDestinationTap: (Destination) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(destinations) { destination in
                    DestinationCardView(destination: destination)
                        .onTapGesture {
                            onDestinationTap(destination)
                        }
                }
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
        }
    }
}
