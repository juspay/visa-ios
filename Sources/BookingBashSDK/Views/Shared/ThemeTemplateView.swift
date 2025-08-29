//
//  ThemeTemplateView.swift
//  VisaActivity
//
//  Created by Apple on 04/08/25.
//

import Foundation
import SwiftUI
import SUINavigation
@_spi(Advanced) import SwiftUIIntrospect

struct ThemeTemplateView<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Color(hex: Constants.HexColors.secondary)
                            .frame(height: geometry.safeAreaInsets.top)
                        Spacer()
                    }
                    .ignoresSafeArea()

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ZStack(alignment: .leading) {
                                Color(hex: Constants.HexColors.secondary)
                                VStack(alignment: .leading) {
                                    header()
                                        .padding(.top, 22)
                                        .padding(.horizontal, 15)
                                
                                    content()
                                        .background(Color.white)
                                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
                        scrollView.bounces = false
                    }
                    .background(Color.white)
                    .clipped()
                }
            }
            .background(Color.white)
    }
}
