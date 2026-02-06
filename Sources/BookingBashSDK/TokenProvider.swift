

import Foundation

extension String {
    func xorDecrypt(key: String) -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        let keyBytes = Array(key.utf8)
        let encryptedBytes = Array(data)
        let decrypted = encryptedBytes.enumerated().map { i, byte in
            byte ^ keyBytes[i % keyBytes.count]
        }
        return String(bytes: decrypted, encoding: .utf8) ?? ""
    }

    func formattedTravelDate() -> String {
        let possibleFormats = [
            "yyyy-MM-dd",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "yyyy-MM-dd HH:mm:ss",
            "dd-MM-yyyy",
            "yyyy/MM/dd"
        ]

        for format in possibleFormats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = format

            if let date = formatter.date(from: self) {
                let displayFormatter = DateFormatter()
                displayFormatter.locale = Locale(identifier: "en_US_POSIX")
                displayFormatter.dateFormat = "EEE, dd MMM yyyy"
                return displayFormatter.string(from: date)
            }
        }

        return self.isEmpty ? "-" : self
    }

    func isTravelDateTodayOrFuture() -> Bool {
        let possibleFormats = [
            "yyyy-MM-dd",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "yyyy-MM-dd HH:mm:ss",
            "dd-MM-yyyy",
            "yyyy/MM/dd",
            "EEE, dd MMM yyyy"
        ]

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        for format in possibleFormats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = format

            if let travelDate = formatter.date(from: self) {
                let travelDay = calendar.startOfDay(for: travelDate)
                return travelDay >= today
            }
        }

        return false
    }
}

struct TokenProvider {
    static func getAuthHeader() -> String? {
        // Fetch the loaded string from Manager
        let encrypted = ConfigurationManager.shared.authHeader
        guard !encrypted.isEmpty else { return nil }
        // Decrypt
        return encrypted.xorDecrypt(key: "BookingBash")
    }
}
