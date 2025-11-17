
import SwiftUI
import Foundation
import SVGKit

enum ImageLoader {
    static func bundleImage(named name: String) -> Image? {
        if let path = Bundle.main.path(forResource: name, ofType: "svg") {
            let svgImage = SVGKImage(contentsOfFile: path)
            if let uiImage = svgImage?.uiImage {
                return Image(uiImage: uiImage)
            }
        }
        if let path = Bundle.main.path(forResource: name, ofType: "png"),
           let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}
