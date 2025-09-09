//
//  AllDestinationsView.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import SwiftUI
import SUINavigation

struct AllDestinationsView: View {
    @ObservedObject var viewModel: SearchDestinationViewModel
    let destinations: [Destination]
    @State private var searchText = ""

    var body: some View {
        GeometryReader { geo in
            ThemeTemplateView(
                header: {
                    ExploreDestinationsHeaderView()
                        .padding(.bottom, 12)
                },
                content: {
                    VStack(spacing: 20) {
                        SearchBarView(
                            viewModel: viewModel,
                            searchPlaceholderText: Constants.HomeScreenConstants.searchDestination,
                            searchText: $searchText
                        )
                        .padding(.horizontal)
                        .padding(.top)
                    DestinationGridView(destinations: destinations, geo: geo)
                }
            })
            .navigationBarBackButtonHidden(true)
        }
    }
}
