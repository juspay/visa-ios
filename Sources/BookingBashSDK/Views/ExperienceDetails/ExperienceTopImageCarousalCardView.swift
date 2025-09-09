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
            Image(experienceDetailCarousalModel.imageName)
                .resizable()
                .frame(width: 245, height: 150)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
}

#Preview {
    ExperienceTopImageCarousalCardView(
        experienceDetailCarousalModel: ExperienceDetailCarousalModel(imageName: Constants.Icons.nature)
    )
}
