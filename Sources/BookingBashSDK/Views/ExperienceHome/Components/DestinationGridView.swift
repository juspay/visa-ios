//
//  DestinationGridView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct DestinationGridView: View {
    let destinations: [Destination]
    let geo: GeometryProxy
    
    var body: some View {
        VStack(spacing: 20) {
            let spacing: CGFloat = 15
            let totalHorizontalPadding: CGFloat = 15 * 2
            let itemWidth = max((geo.size.width - totalHorizontalPadding - spacing) / 2, 0)
            
            LazyVGrid(
                columns: [
                    GridItem(.fixed(itemWidth), spacing: spacing),
                    GridItem(.fixed(itemWidth), spacing: spacing)
                ],
                spacing: spacing
            ) {
                ForEach(destinations) { destination in
                    DestinationCardView(destination: destination, itemWidth: itemWidth)
                }
            }
        }
        
    }
}
