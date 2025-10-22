//
//  ReviewListView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct ReviewListView: View {
    @ObservedObject var viewModel: ExperienceDetailViewModel
    @State private var shouldShowRatingFilterOptions: Bool = false
    
    var body: some View {
        ThemeTemplateView(header: {
            Text(String(format: Constants.DetailScreenConstants.reviewsText, 12500))
                .font(.custom(Constants.Font.openSansBold, size: 18))
                .foregroundStyle(.white)
            
        }, content: {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 4) {
                    if let starImage = ImageLoader.bundleImage(named: Constants.Icons.star) {
                        starImage
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                    
                    Text("4.5")
                        .font(.custom(Constants.Font.openSansBold, size: 22))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                }
                .padding(.leading)
                VStack(spacing: 8) {
                    RatingBarView(rating: 5, progress: 0.6, count: "6K")
                    RatingBarView(rating: 4, progress: 0.5, count: "3K")
                    RatingBarView(rating: 3, progress: 0.4, count: "2K")
                    RatingBarView(rating: 2, progress: 0.3, count: "1K")
                    RatingBarView(rating: 1, progress: 0.2, count: "5000")
                }
                .padding(.horizontal)
                
                HStack(spacing: 0) {
                    Text(Constants.DetailScreenConstants.sortBy)
                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    HStack(spacing: 0) {
                        Text(Constants.DetailScreenConstants.mostRelevant)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                        if let arrowImage = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                            arrowImage
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color(hex: Constants.HexColors.primary))
                        }
                    }
                    .onTapGesture(perform: {
                        shouldShowRatingFilterOptions = true
                    })
                    
                }
                .padding(.horizontal)
                
                ForEach(viewModel.reviews) { review in
                    ReviewCardView(review: review)
                }
            }
            .padding(.vertical)
        })
        .navigationBarBackButtonHidden(true)
        .overlay(content: {
            BottomSheetView(isPresented: $shouldShowRatingFilterOptions) {
                RadioOptionsListView(
                    title: Constants.DetailScreenConstants.sort,
                    options: viewModel.sortRatingsOptions,
                    selectedOption: viewModel.selectedOption,
                    onSelect: { viewModel.selectedOption = $0 },
                    titleKeyPath: \.title
                )
            }
        })
    }
}
