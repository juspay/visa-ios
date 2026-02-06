//
//  ExperienceTopImageCarousal.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI

struct ExperienceTopImageCarousalListView: View {
    let experienceDetailCarousalModel: [ExperienceDetailCarousalModel]
    let imageURLs: [URL]
    @State private var showFullImage = false
    @State private var selectedIndex: Int = 0

    
    init(experienceDetailCarousalModel: [ExperienceDetailCarousalModel], showFullImage: Bool = false) {
        self.experienceDetailCarousalModel = experienceDetailCarousalModel
        self._showFullImage = State(initialValue: showFullImage)
        self.imageURLs = experienceDetailCarousalModel.compactMap { URL(string: $0.imageUrl) }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(Array(experienceDetailCarousalModel.enumerated()), id: \.1.id) { index, carousal in
                    ExperienceTopImageCarousalCardView(experienceDetailCarousalModel: carousal) {
                        selectedIndex = index
                        showFullImage = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showFullImage) {
            FullScreenImageView(
                imageURLs: imageURLs,
                isPresented: $showFullImage,
                selectedIndex: $selectedIndex
            )
        }
    }
}
