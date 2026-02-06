//
//  ExperienceTopImageCarousalCardView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI

struct ExperienceTopImageCarousalCardView: View {
    let experienceDetailCarousalModel: ExperienceDetailCarousalModel
    let onTap: () -> Void

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: experienceDetailCarousalModel.imageUrl)) { image in
                image.resizable()
            } placeholder: {
                if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                    placeholder
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.gray
                }
            }
            .frame(width: 245, height: 150)
            .onTapGesture {
                onTap()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ExperienceTopImageCarousalCardView(
        experienceDetailCarousalModel: ExperienceDetailCarousalModel(imageUrl: Constants.Icons.nature), onTap: {}
    )
}
