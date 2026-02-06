
import Foundation
import SwiftUI
import SUINavigation

struct ExperienceListView: View {
    @Binding var experiences: [Experience]
    var onTap: ((Experience) -> Void)? = nil
    
    @State private var shouldNavigateToDetail: Bool = false
    @State private var selectedExperience: Experience?
    @State private var selectedProductCode: String? = nil
    
    // Adaptive grid: 1 column on narrow screens, 2+ when there's room
    private var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 320, maximum: 600), spacing: 15)
        ]
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                content
            }
            .padding(.horizontal, 15)
        }
        .navigation(isActive: $shouldNavigateToDetail, id: "ExperienceDetailView") {
            if let selectedExperience = selectedExperience {
                ExperienceDetailView(
                    productCode: selectedExperience.productCode,
                    currency: currencyGlobal
                )
            }
        }
    }

    // extracted view builder to avoid duplication
    private var content: some View {
        ForEach($experiences) { $experience in
            ExperienceCardView(experience: $experience)
                .onTapGesture {
                    selectedExperience = experience
                    selectedProductCode = experience.productCode
                    shouldNavigateToDetail = true
                    onTap?(experience)
                }
        }
    }
}
