//
//  ExperienceTopImageCarousalCardView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import SwiftUI

struct ExperienceTopImageCarousalCardView: View {
    let experienceDetailCarousalModel: ExperienceDetailCarousalModel
    @State private var showFullImage = false
    
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
                    Color.gray // or a placeholder image
                }
            }
            .frame(width: 245, height: 150)
            .onTapGesture {
                showFullImage = true
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .fullScreenCover(isPresented: $showFullImage) {
            FullScreenImageView(
                imageURL: URL(string: experienceDetailCarousalModel.imageUrl),
                isPresented: $showFullImage
            )
        }
    }
}

#Preview {
    ExperienceTopImageCarousalCardView(
        experienceDetailCarousalModel: ExperienceDetailCarousalModel(imageUrl: Constants.Icons.nature)
    )
}
