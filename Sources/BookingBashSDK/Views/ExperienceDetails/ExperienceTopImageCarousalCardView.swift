//
//  ExperienceTopImageCarousalCardView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI

struct ExperienceTopImageCarousalCardView: View {
    let experienceDetailCarousalModel: ExperienceDetailCarousalModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: experienceDetailCarousalModel.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                Color.gray // or a placeholder image
            }
            .frame(width: 245, height: 150)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
}

#Preview {
    ExperienceTopImageCarousalCardView(
        experienceDetailCarousalModel: ExperienceDetailCarousalModel(imageUrl: Constants.Icons.nature)
    )
}
