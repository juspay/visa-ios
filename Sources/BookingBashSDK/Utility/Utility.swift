
import UIKit

func openWhatsApp() {
    let url = URL(string: "https://wa.me/971505601104")!

    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
