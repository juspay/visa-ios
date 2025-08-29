//
//  ExperienceListView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation
import SwiftUI

struct ExperienceListView: View {
    let experiences: [Experience]

    var body: some View {
        LazyVStack(spacing: 15) {
            ForEach(experiences) { experience in
                ExperienceCardView(experience: experience)
            }
        }
        .padding(.horizontal, 15)
    }
}

