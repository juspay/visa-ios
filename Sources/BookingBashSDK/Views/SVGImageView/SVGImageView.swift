//
//  SVGImageView.swift
//  VisaActivity
//
//

import SwiftUI
import SVGKit

struct SVGImageView: View {
    let url: URL
    @State private var uiImage: UIImage? = nil

    var body: some View {
        Group {
            if let img = uiImage {
                Image(uiImage: img)
                    .resizable()
                    .frame(width: 20, height: 14)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 20, height: 14)
            }
        }
        .onAppear {
            loadSVG(from: url)
        }
        .onChange(of: url) { newURL in
            loadSVG(from: newURL)
        }
    }

    private func loadSVG(from url: URL) {
        uiImage = nil // Reset previous image
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url),
                  let svgImage = SVGKImage(data: data) else { return }
            svgImage.size = CGSize(width: 20, height: 14)
            DispatchQueue.main.async {
                uiImage = svgImage.uiImage
            }
        }
    }
}
