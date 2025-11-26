import SwiftUI
import SVGKit

enum ImageLoader {

    static func bundleImage(named name: String) -> Image? {
        var url: URL?

        // 1️⃣ Try SVG — Bundle.module (SPM)
        #if SWIFT_PACKAGE
        url = Bundle.module.url(forResource: name, withExtension: "svg")
        #endif

        // 2️⃣ Fallback SVG — Bundle.main
        if url == nil {
            url = Bundle.main.url(forResource: name, withExtension: "svg")
        }

        // Try loading SVG if URL was found
        if let fileUrl = url,
           let svgImage = SVGKImage(contentsOf: fileUrl)?.uiImage {
            return Image(uiImage: svgImage)
        }

        // Reset URL for PNG logic
        url = nil

        // 3️⃣ Try PNG — Bundle.module (SPM)
        #if SWIFT_PACKAGE
        url = Bundle.module.url(forResource: name, withExtension: "png")
        #endif

        // 4️⃣ Fallback PNG — Bundle.main
        if url == nil {
            url = Bundle.main.url(forResource: name, withExtension: "png")
        }

        // Try loading PNG if URL was found
        if let fileUrl = url,
           let data = try? Data(contentsOf: fileUrl),
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        }

        return nil
    }
}
