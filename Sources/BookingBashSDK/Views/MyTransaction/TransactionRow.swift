import SwiftUI

struct TransactionRow: View {
    let item: Booking
    
    // MARK: - Savings Text Function
    private func createSavingsText(savingAmount: Double, currency: String) -> AttributedString {
        var text = AttributedString(Constants.TransactionRowConstants.youAreSaving)
        text.foregroundColor = .gray
        
        var value = AttributedString("\(Int(savingAmount)) \(currency)")
        value.foregroundColor = Color(hex: Constants.HexColors.greenShade)
        value.font = .system(size: 14, weight: .bold)
        text.append(value)
        return text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Top: image + title + booking details
            HStack(alignment: .top, spacing: 12) {
                
                if let uiImage = UIImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 76, height: 76)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    // Fallback if image not found
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 76, height: 76)
                        .overlay(
                            Image(systemName: Constants.TransactionRowConstants.systemPhoto)
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.productTitle)
                        .font(.custom("OpenSans-SemiBold", size: 14))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text(Constants.TransactionRowConstants.bookingId)
                            .foregroundColor(.black)
                            .font(.custom("OpenSans-SemiBold", size: 12))
                        Text(item.bookingRef)
                            .foregroundColor(.gray)
                            .font(.custom("OpenSans-SemiBold", size: 12))
                        
                        Spacer()
                    }
                    .font(.subheadline)
                    
                    HStack(spacing: 4) {
                        Text(Constants.TransactionRowConstants.bookingDate)
                            .font(.custom("OpenSans-SemiBold", size: 12))
                            .foregroundColor(.black)
                        Text(DateFormatter.shortDate.string(from: item.bookingDate))
                            .font(.custom("OpenSans-SemiBold", size: 12))
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                }
                
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(DateFormatter.shortDate.string(from: item.travelDate), systemImage: Constants.TransactionRowConstants.calendar)
                        .font(.custom("OpenSans-SemiBold", size: 12))
                    Spacer()
                    if let icon = ImageLoader.bundleImage(named: Constants.Icons.usergray) {
                        HStack(spacing: 6) {
                            icon
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.secondary)
                            Text(item.travellerText)
                                .font(.custom("OpenSans-SemiBold", size: 12))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Label(item.travellerText, image: Constants.Icons.usergray)
                            .font(.custom("OpenSans-SemiBold", size: 12))
                    }
                }
                
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Label(item.timeText, systemImage: Constants.TransactionRowConstants.clock)
                    .font(.custom("OpenSans-SemiBold", size: 12))
                    .foregroundColor(.secondary)
                
                if let strikeout = item.price.strikeout {
                    Label {
                        Text(createSavingsText(
                            savingAmount: strikeout.savingAmount,
                            currency: item.price.currency
                        ))
                        .font(.custom("OpenSans-SemiBold", size: 12))
                    } icon: {
                        if let savingIcon = ImageLoader.bundleImage(named: Constants.Icons.savingGray) {
                                                    savingIcon
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .colorMultiply(.gray)
                                                }
                    }
                }
            }
            
            // Bottom: Status
            HStack {
                Spacer()
                Text(Constants.TransactionRowConstants.status)
                    .font(.custom("OpenSans-SemiBold", size: 12))
                    .foregroundColor(.gray)
                
                Text(item.status.rawValue.capitalized)
                    .font(.custom("OpenSans-SemiBold", size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(item.status.color)
                    .foregroundColor(.white)
                    .cornerRadius(6)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
    }
}
