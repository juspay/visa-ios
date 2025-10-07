//
//  ExperienceTopImageCarousal.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI

struct ExperienceTopImageCarousalListView: View {
    let experienceDetailCarousalModel: [ExperienceDetailCarousalModel]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(experienceDetailCarousalModel) { carousal in
                    ExperienceTopImageCarousalCardView(experienceDetailCarousalModel: carousal)
                }
            }
        }
        
    }
}

