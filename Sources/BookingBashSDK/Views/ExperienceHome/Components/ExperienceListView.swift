//
//  ExperienceListView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI
import SUINavigation

struct ExperienceListView: View {
    let experiences: [Experience]
    var onTap: ((Experience) -> Void)? = nil
    @State private var shouldNavigateToDetail: Bool = false
    @State private var selectedExperience: Experience?
    @State private var selectedProductCode: String? = nil

    var body: some View {
        LazyVStack(spacing: 15) {
            ForEach(experiences) { experience in
                ExperienceCardView(experience: experience)
                    .onTapGesture {
                        selectedExperience = experience
                        selectedProductCode = experience.productCode
                        shouldNavigateToDetail = true
                        
                        onTap?(experience)
                    }
            }
        }
        .padding(.horizontal, 15)
        .navigation(isActive: $shouldNavigateToDetail, id: "ExperienceDetailView") {
            if let selectedExperience = selectedExperience {
                ExperienceDetailView(
                    productCode: selectedExperience.productCode,
                    currency: "AED"
                )
            }
        }
    }
}
