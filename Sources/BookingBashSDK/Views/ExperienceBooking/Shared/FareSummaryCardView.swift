
import Foundation
import SwiftUI

struct FareSummaryCardView: View {
    let fairSummaryData: [FareItem]
    var totalPrice: String
    var shouldShowTopBanner: Bool = true
    var savingsText: String?
    var fareSummaryOnChecoutView: Bool = false
    var pgPrice: PGPrice? = nil
    var needCollapsableView: Bool = false
    var ismarkup: Bool = false
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if shouldShowTopBanner {
                topBannerView
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(Constants.BookingStatusScreenConstants.fareSummary)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#2C3E50"))
                        .padding(.top, 14)
                        .padding(.bottom, 14)
                    
                    Spacer()
                    
                    if needCollapsableView {
                        if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                            arrow
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(hex: Constants.HexColors.primary))
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                .animation(.easeInOut(duration: 0.25), value: isExpanded)
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if needCollapsableView {
                        isExpanded.toggle()
                    }
                }
                
                if needCollapsableView {
                    if isExpanded {
                        fareSummaryDetailView
                    }
                } else {
                    fareSummaryDetailView
                }
            }
            .padding(.horizontal, 14)
            .background(Color.white)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private var topBannerView: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#1A3A52"),
                    Color(hex: "#2E5B3F"),
                    Color(hex: "#4CAF50")
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 60)

            HStack(alignment: .center, spacing: 8) {
                if let savingIcon = ImageLoader.bundleImage(named: Constants.Icons.savingGray) {
                    savingIcon
                        .resizable()
                        .frame(width: 25, height: 25)
                        .colorMultiply(.white)
                }

                if let savingsText = savingsText {
                    Text(savingsText)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }

    private var fareSummaryDetailView: some View {
        VStack(alignment: .leading) {
            if fairSummaryData.isEmpty {
                HStack(alignment: .center, spacing: 8) {
                    Text("Loading fare details...")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#7F8C8D"))
                    Spacer()
                }
                .padding(.bottom, 12)
            } else {
                ForEach(fairSummaryData.indices, id: \.self) { index in
                    let fareItem = fairSummaryData[index]
                    HStack(alignment: .center, spacing: 8) {
                        Text(fareItem.title)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#5A5A5A"))
                        Spacer()
                        Text(fareItem.value)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(fareItem.isDiscount ? .green : .gray)
                    }
                    .padding(.bottom, 12)
                }
            }

            Divider()
                .background(Color(hex: "#E0E0E0"))
                .padding(.bottom, 14)

            HStack(alignment: .center, spacing: 8) {
                Text(Constants.BookingStatusScreenConstants.totalAmount)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#2C3E50"))
                Spacer()
                Text(" \(totalPrice)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#2C3E50"))
            }
            .padding(.bottom, 10)

            Text("Prices inclusive of taxes")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#95A5A6"))
                .padding(.bottom, 14)
            
            if fareSummaryOnChecoutView, let totalAmount = pgPrice?.totalAmount, let currency = pgPrice?.currency, let currencyName = pgPrice?.currencyName , ismarkup {
                Text("Please note that your card will be charged in \(currencyName) (\(currency)), and the amount payable will be \(currency) \(totalAmount.commaSeparated())")
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color(hex: Constants.HexColors.bgPremierWeak))
                    .foregroundColor(Color(hex: Constants.HexColors.neutral))
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .cornerRadius(4, corners: .allCorners)
                    .padding(.bottom, 20)
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
