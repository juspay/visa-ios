//
//  InfoDetailListView.swift
//  VisaActivity
//
//  Created by Apple on 01/08/25.
//

import Foundation
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect


struct InfoDetailListView: View {
    let sections: [InfoDetailModel]
    let showBullets: Bool
    let experienceName: String

    var body: some View {
        ThemeTemplateView(header: {
            HStack {
                Text(experienceName)
                    .font(.custom(Constants.Font.openSansBold, size: 18))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.bottom, 6)
        }, content: {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(sections) { section in
                    InfoDetailView(section: section, showBullets: showBullets)
                }
            }
            .padding()
        })
        .navigationBarBackButtonHidden(true)
    }
}
