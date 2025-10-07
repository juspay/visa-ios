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

// Helper function to load an image from the bundle root
func bundleImage(named name: String) -> Image? {
    // First try to load SVG images from Resources/Images folder
    if let path = Bundle.main.path(forResource: name, ofType: "svg"),
       let data = NSData(contentsOfFile: path),
       let uiImage = UIImage(data: data as Data) {
        return Image(uiImage: uiImage)
    }
    
    // Fallback to PNG images from Resources/Images folder
    if let path = Bundle.main.path(forResource: name, ofType: "png"),
       let uiImage = UIImage(contentsOfFile: path) {
        return Image(uiImage: uiImage)
    }
    
    return nil
}

struct ThemeTemplateView<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content
    @Environment(\.dismiss) private var dismiss
    
    // flag to decide if ScrollView should be applied
    var needsScroll: Bool
    
    var onBack: (() -> Void)? = nil
    
    init(needsScroll: Bool = true,
         @ViewBuilder header: @escaping () -> Header,
         @ViewBuilder content: @escaping () -> Content,
         onBack: (() -> Void)? = nil) {
        self.header = header
        self.content = content
        self.needsScroll = needsScroll
        self.onBack = onBack
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

                        Button(action: { onBack?() ?? dismiss() }) {
                            if let backButton = bundleImage(named: "BackButton") {
                                backButton
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            } else {
                                Image("BackButton")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                        }

                        Spacer()
                        
                        HStack(spacing: 12) {
                            if let logo = bundleImage(named: "Logos") {
                                logo
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                            } else {
                                // Use PNG from Resources/Images as fallback
                                Image("Logos")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                            }
                            
//                           
                            if let bookingBashLogo = bundleImage(named: "BookingBashLogo") {
                                        bookingBashLogo
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 30)
                                    } else {
                                        Image("BookingBashLogo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 30)
                                    }
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
