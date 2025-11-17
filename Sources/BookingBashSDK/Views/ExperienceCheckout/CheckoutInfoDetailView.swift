
import Foundation
import SwiftUI

struct CheckoutInfoDetailView: View {
    let title: String
    let items: [String]
    let showBullets: Bool
    let experienceName: String
    
    var body: some View {
        
        // Create fallback content if items are empty
        let displayItems = items.filter { !$0.isEmpty }
        let finalItems: [String] = displayItems.isEmpty ? getFallbackItems(for: title) : displayItems
        
        
        return ThemeTemplateView(header: {
            HStack {
                Text(experienceName.isEmpty ? "Experience Details" : experienceName)
                    .font(.custom(Constants.Font.openSansBold, size: 18))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.bottom, 6)
        }, content: {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                        .padding(.bottom, 4)
                    
                    ForEach(finalItems, id: \.self) { item in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            if showBullets {
                                Text(Constants.BookingStatusScreenConstants.dot)
                                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                    .padding(.leading, 6)
                            }
                            Text(item)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        })
        .navigationBarBackButtonHidden(true)
    }
    
    // Helper function to provide fallback content
    private func getFallbackItems(for title: String) -> [String] {
        switch title.lowercased() {
        case "highlights":
            return [
                "Experience authentic local culture",
                "Visit iconic landmarks and hidden gems", 
                "Learn from knowledgeable local guides",
                "Small group for personalized experience"
            ]
        case "what's included":
            return [
                "Professional guide",
                "All entrance fees",
                "Transportation as per itinerary", 
                "Complimentary refreshments"
            ]
        case "what's not included", "what's excluded":
            return [
                "Personal expenses",
                "Gratuities",
                "Food and beverages (unless specified)",
                "Travel insurance"
            ]
        case "cancellation policy":
            return [
                "Free cancellation available",
                "Cancel up to 24 hours before the experience starts for a full refund"
            ]
        case "know before you go":
            return [
                "Please arrive 15 minutes before the scheduled start time",
                "Comfortable walking shoes recommended",
                "Bring valid ID for verification", 
                "Activity may be affected by weather conditions"
            ]
        default:
            return ["Information not available at this time"]
        }
    }
}
