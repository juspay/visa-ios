//
//  SimilarExperiencesView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import SwiftUI

struct SimilarExperiencesView: View {
    let experienceDetailCarousalModel: [ExperienceDetailCarousalModel]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Constants.DetailScreenConstants.similarExperiences)
                .font(.custom(Constants.Font.openSansBold, size: 16))
                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(experienceDetailCarousalModel) { carousal in
                        ExperienceTopImageCarousalCardView(experienceDetailCarousalModel: carousal)
                    }
                }
            }
        }
        .padding(.top, 16)
    }
}
