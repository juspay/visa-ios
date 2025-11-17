import SwiftUI

  struct MobileCodeData {
      static func loadCodes() -> [MobileCode] {
          var url: URL?

          // Try Bundle.module first (for SPM) - use #if to check compile-time availability
          #if SWIFT_PACKAGE
          url = Bundle.module.url(forResource: "MobileCodes", withExtension: "json")
          #endif

          // Fallback to Bundle.main (for main app/submodule)
          if url == nil {
              url = Bundle.main.url(forResource: "MobileCodes", withExtension: "json")
          }

          guard let fileUrl = url else {
              return []
          }

          do {
              let data = try Data(contentsOf: fileUrl)
              let decoded = try JSONDecoder().decode([MobileCode].self, from: data)
              return decoded
          } catch {
              return []
          }
      }

      static let allCodes: [MobileCode] = loadCodes()
  }
