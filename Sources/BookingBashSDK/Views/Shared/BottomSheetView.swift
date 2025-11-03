//
//  BottomSheetView.swift
//  VisaActivity
//
//  Created by Apple on 03/08/25.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    let sheetHeight: CGFloat?
    let content: Content
    var productCode: String?
    var isDragToDismissEnabled: Bool
    
    @State private var dragOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0
    
    private let dismissThreshold: CGFloat = 100
    
    init(
        isPresented: Binding<Bool>,
        sheetHeight: CGFloat? = nil,
        @ViewBuilder content: () -> Content,
        productCode: String? = nil,
        isDragToDismissEnabled: Bool = true
    ) {
        self._isPresented = isPresented
        self.sheetHeight = sheetHeight
        self.content = content()
        self.productCode = productCode
        self.isDragToDismissEnabled = isDragToDismissEnabled
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                Color(hex: Constants.HexColors.secondary).opacity(0.9)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                    }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        content
                            .frame(maxWidth: .infinity, alignment: .top)
                            .padding(.top, 16)
                            .padding(.bottom, getBottomInset() + 16)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ScrollOffsetPreferenceKey.self,
                                                    value: geo.frame(in: .named(Constants.SharedConstants.botoomSheetScrollId)).minY)
                                }
                                    .frame(height: 0)
                            )
                            .coordinateSpace(name: Constants.SharedConstants.botoomSheetScrollId)
                    }
                    .frame(maxWidth: .infinity)
                    .applySheetHeight(sheetHeight)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
                    )
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture(minimumDistance: 10)
                            .onChanged { value in
                                if scrollOffset <= 0 && value.translation.height > 0 {
                                    dragOffset = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if isDragToDismissEnabled {
                                    if dragOffset > dismissThreshold {
                                        dismissSheet()
                                    } else {
                                        withAnimation(.spring()) {
                                            dragOffset = 0
                                        }
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        dragOffset = 0
                                    }
                                }
                            }
                    )
                }
                .edgesIgnoringSafeArea(.bottom)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    dragOffset = 0
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
    
    private func dismissSheet() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
            dragOffset = 0
        }
    }
    
    private func getBottomInset() -> CGFloat {
        return UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom }
            .first ?? 0
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private extension View {
    @ViewBuilder
    func applySheetHeight(_ height: CGFloat?) -> some View {
        if let height = height {
            self.frame(height: height)
        } else {
            self.fixedSize(horizontal: false, vertical: true)
        }
    }
}
