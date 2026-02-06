//
//  FullScreenImageView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 21/11/25.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageURLs: [URL]
    @Binding var isPresented: Bool
    @Binding var selectedIndex: Int

    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()

            TabView(selection: $selectedIndex) {
                ForEach(imageURLs.indices, id: \.self) { index in
                    ZoomableImageView(imageURL: imageURLs[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            // MARK: - Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}

struct ZoomableImageView: View {
    let imageURL: URL

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let img):
                    img.resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .offset(offset)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .gesture(magnificationGesture())
                        .simultaneousGesture(dragGesture(), including: scale > 1 ? .all : .none)

                case .failure:
                    if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                        placeholder
                            .resizable()
                            .scaledToFill()
                    } else {
                        Text("Image failed to load")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }

                default:
                    ProgressView()
                        .scaleEffect(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }

    // MARK: - Gestures
    private func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(lastScale * value, 1), 5)
            }
            .onEnded { _ in
                lastScale = scale
                if scale == 1 {
                    withAnimation(.spring()) {
                        offset = .zero
                        lastOffset = .zero
                    }
                }
            }
    }

    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
}
