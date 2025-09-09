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
    @Environment(\.dismiss) private var dismiss
    
    // flag to decide if ScrollView should be applied
    var needsScroll: Bool
    
    init(needsScroll: Bool = true,
         @ViewBuilder header: @escaping () -> Header,
         @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content
        self.needsScroll = needsScroll
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Color(hex: Constants.HexColors.secondary)
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .ignoresSafeArea()
                
                Group {
                    if needsScroll {
                        ScrollView(.vertical, showsIndicators: false) {
                            mainBody
                        }
                        .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
                            scrollView.bounces = false
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
                    //  Custom top bar
                    HStack {
                        Button(action: { dismiss() }) {
                            Image("BackButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            Image("logoVisa")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                            
                            Image("BookingBashLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    
                    // Dynamic header
                    header()
                        .padding(.horizontal, 15)
                        .padding(.bottom, 6)
                    
                    // Content area
                    content()
                        .background(Color.white)
                        .clipShape(
                            RoundedCorner(radius: 16,
                                          corners: [.topLeft, .topRight])
                        )
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

//struct ThemeTemplateView<Header: View, Content: View>: View {
//    let header: () -> Header
//    let content: () -> Content
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack {
//                    Color(hex: Constants.HexColors.secondary)
//                        .frame(height: geometry.safeAreaInsets.top)
//                    Spacer()
//                }
//                .ignoresSafeArea()
//                
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(spacing: 0) {
//                        ZStack(alignment: .leading) {
//                            Color(hex: Constants.HexColors.secondary)
//                            
//                            VStack(alignment: .leading, spacing: 0) {
//                                //  Custom top bar
//                                HStack {
//                                    Button(action: {
//                                        // back action here
//                                        dismiss()
//                                    }) {
//                                        Image("BackButton")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 25, height: 25)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    HStack(spacing: 12) {
//                                        Image("logoVisa")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(height: 40)
//                                        
//                                        Image("BookingBashLogo")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(height: 30)
//                                    }
//                                }
//                                .padding(.horizontal, 15)
//                                .padding(.top, 12)
//                                .padding(.bottom, 8)
//                                
//                                // Existing dynamic header
//                                header()
//                                    .padding(.horizontal, 15)
//                                    .padding(.bottom, 6)
//                                
//                                // Content area
//                                content()
//                                    .background(Color.white)
//                                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//                }
//                .introspect(.scrollView, on: .iOS(.v15...)) { scrollView in
//                    scrollView.bounces = false
//                }
//                .background(Color.white)
//                .clipped()
//            }
//        }
//        .background(Color.white)
//    }
//}
