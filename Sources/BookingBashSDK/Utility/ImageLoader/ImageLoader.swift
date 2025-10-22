
import SwiftUI
import Foundation
import SVGKit

enum ImageLoader {
    static func bundleImage(named name: String) -> Image? {
        // Try SVG using SVGKit
        if let path = Bundle.main.path(forResource: name, ofType: "svg") {
            print("CHECK_SVG --> Loading SVG image from path: \(path)")
            let svgImage = SVGKImage(contentsOfFile: path)
            if let uiImage = svgImage?.uiImage {
                return Image(uiImage: uiImage)
            }
        }
        
        // Try PNG fallback
        if let path = Bundle.main.path(forResource: name, ofType: "png"),
           let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        }
        print("CHECK_SVG -->  ")
        return nil
    }
}
