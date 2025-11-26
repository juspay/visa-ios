//
//  FullScreenImageView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 21/11/25.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageURL: URL?
    @Binding var isPresented: Bool

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                VStack {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let img):
                            img.resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(scale)
                                // 💡 Re-apply offset to allow panning
                                .offset(offset)
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            scale = min(max(lastScale * value, 1.0), 5.0)
                                        }
                                        .onEnded { _ in
                                            lastScale = scale
                                            // Reset offset if scaled back to original size
                                            if scale == 1.0 {
                                                withAnimation(.spring()) {
                                                    offset = .zero
                                                    lastOffset = .zero
                                                }
                                            }
                                        }
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if scale > 1.0 {
                                                offset = CGSize(
                                                    width: lastOffset.width + value.translation.width,
                                                    height: lastOffset.height + value.translation.height
                                                )
                                            }
                                        }
                                        .onEnded { value in
                                            if scale > 1.0 {
                                                lastOffset = offset
                                            } else {
                                                // If scale is 1.0, reset offset after dragging (optional)
                                                offset = .zero
                                                lastOffset = .zero
                                            }
                                        }
                                )
                            
                        case .failure:
                            Text("Image failed to load")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                        default:
                            ProgressView()
                                .scaleEffect(2)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            // Close Button
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding()
            }
            .offset(x: -10, y: 10)
        }
    }
}

#Preview {
    FullScreenImageView(imageURL: nil, isPresented: .constant(false))
}
