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

typealias ScrollAnchorID = AnyHashable

struct ThemeTemplateView<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content
    var headerHasPadding: Bool
    var contentHasRoundedCorners: Bool

    @Environment(\.dismiss) private var dismiss
    
    var needsScroll: Bool
    @Binding var scrollToID: ScrollAnchorID?
    var onBack: (() -> Void)? = nil
    var hideBackButton: Bool
    
    init(
        needsScroll: Bool = true,
        scrollToID: Binding<ScrollAnchorID?> = .constant(nil),
        headerHasPadding: Bool = true,
        contentHasRoundedCorners : Bool = true,
        hideBackButton: Bool = false,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content,
        onBack: (() -> Void)? = nil
    ) {
        self.header = header
        self.contentHasRoundedCorners = contentHasRoundedCorners
        self.content = content
        self.needsScroll = needsScroll
        self._scrollToID = scrollToID
        self.headerHasPadding = headerHasPadding
        self.hideBackButton = hideBackButton
        self.onBack = onBack
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Top safe-area background
                VStack {
                    Color(hex: Constants.HexColors.secondary)
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .ignoresSafeArea()
                
                Group {
                    if needsScroll {
                        ScrollViewReader { proxy in
                            ScrollView(.vertical, showsIndicators: false) {
                                mainBody
                            }
                            .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
                                scrollView.bounces = false
                            }
                            .onChange(of: scrollToID) { id in
                                guard let id else { return }

                                withAnimation(.easeInOut) {
                                    proxy.scrollTo(id, anchor: .center)
                                }

                                // reset so it can be triggered again
                                DispatchQueue.main.async {
                                    scrollToID = nil
                                }
                            }
                        }
                    } else {
                        mainBody
                    }
                }
                .background(Color.white)
                .clipped()
            }
        }
        .background(Color.white)
    }
    
    private var mainBody: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Color(hex: Constants.HexColors.secondary)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Custom top bar
                    HStack {
                        if !hideBackButton {
                            backButton
                            Spacer()
                            logos
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                  
                    // Dynamic header
                    if headerHasPadding {
                        header()
                            .padding(.horizontal, 15)
                            .padding(.bottom, 6)
                    } else {
                        header()
                            .padding(.bottom, 6)
                    }
                    
                    // Content area
//                    content()
//                        .background(Color.white)
//                        .clipShape(
//                            RoundedCorner(
//                                radius: 16,
//                                corners: [.topLeft, .topRight]
//                            )
//                        )
                    if contentHasRoundedCorners {
                        content()
                            .background(Color.white)
                            .clipShape(
                                RoundedCorner(radius: 16, corners: [.topLeft, .topRight])
                            )
                    } else {
                        content()
                            .background(Color.white) // plain
                    }

                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Components
    
    private var backButton: some View {
        Button(action: { onBack?() ?? dismiss() }) {
            if let backButton = ImageLoader.bundleImage(named: Constants.Icons.backButton) {
                backButton
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            } else {
                Image(Constants.Icons.backButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
            }
        }
    }
    
    private var logos: some View {
        HStack(spacing: 12) {
//            if let logo = ImageLoader.bundleImage(named: Constants.Icons.logos) {
//                logo
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 40)
//            } else {
//                Image(Constants.Icons.logos)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 40)
//            }
            
            if let bookingBashLogo = ImageLoader.bundleImage(named: Constants.Icons.bookingBash) {
                bookingBashLogo
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            } else {
                Image(Constants.Icons.bookingBash)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
        }
    }
}


