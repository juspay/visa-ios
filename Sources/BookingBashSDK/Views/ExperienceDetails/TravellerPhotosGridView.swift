//
//  TravellerPhotosGridView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI

struct TravellerPhotosGridView: View {
    @ObservedObject var viewModel: ExperienceDetailViewModel
    let spacing: CGFloat = 16
    let horizontalPadding: CGFloat = 14
    @State var showSortSheet = false
    
    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(header: {
                Text(Constants.DetailScreenConstants.travelerPhotos)
                    .font(.custom(Constants.Font.openSansBold, size: 18))
                    .foregroundStyle(.white)
            }, content: {
                VStack {
                    let totalHorizontalPadding = horizontalPadding * 2
                    let itemWidth = max((geo.size.width - totalHorizontalPadding - spacing) / 2, 0)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.fixed(itemWidth), spacing: spacing),
                            GridItem(.fixed(itemWidth), spacing: spacing)
                        ],
                        spacing: spacing
                    ) {
                        ForEach(viewModel.images.prefix(6)) { item in
                            ZStack {
                                Image(item.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: itemWidth, height: 150)
                                    .clipped()
                                    .cornerRadius(14)
                                    .onTapGesture {
                                        showSortSheet = true
                                    }
                                
                                if let text = item.overlayText {
                                    Color.black.opacity(0.4)
                                        .frame(width: itemWidth, height: 150)
                                        .cornerRadius(14)
                                    
                                    Text(text)
                                        .font(.custom(Constants.Font.openSansBold, size: 18))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                }
                .padding(.top)
            })
            .navigationBarBackButtonHidden(true)
            .overlay(content: {
                BottomSheetView(isPresented: $showSortSheet) {
                    TravellerPhotosExpandedView()
                }
            })
        }
    }
}

