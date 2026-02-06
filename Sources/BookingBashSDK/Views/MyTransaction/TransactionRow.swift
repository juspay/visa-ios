import SwiftUI

struct TransactionRow: View {
    let item: Booking
    var participantsSummary: String = ""

    init(item: Booking) {
        self.item = item
        let pricePerAge = item.price.pricePerAge

        let parts: [String] = pricePerAge.compactMap { item in
            guard item.count > 0 else { return nil }

            let label: String

            switch item.bandId.uppercased() {
            case "ADULT":
                label = item.count == 1 ? "Adult" : "Adults"
            case "CHILD":
                label = item.count == 1 ? "Child" : "Children"
            case "INFANT":
                label = item.count == 1 ? "Infant" : "Infants"
            case "FAMILY":
                label = item.count == 1 ? "Family" : "Families"
            case "PERSON":
                label = item.count == 1 ? "Person" : "People"
            case "CUSTOM":
                label = "Custom"
            default:
                label = item.count == 1 ? item.bandId.capitalized : "\(item.bandId.capitalized)s"
            }

            return "\(item.count) \(label)"
        }

        participantsSummary = parts.isEmpty ? "No participants" : parts.joined(separator: ", ")
    }
    
    // MARK: - Savings Text Function
    private func createSavingsText(savingAmount: Double, currency: String) -> AttributedString {
        var text = AttributedString(Constants.TransactionRowConstants.youAreSaving)
        text.foregroundColor = .gray
        var value = AttributedString("\(savingAmount.commaSeparated()) \(currency)")
        value.foregroundColor = Color(hex: Constants.HexColors.greenShade)
        value.font = .system(size: 14, weight: .bold)
        text.append(value)
        return text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Top: image + title + booking details
            HStack(alignment: .top, spacing: 12) {
                //item.
                if let thumbnailUrl = URL(string: item.thumbnail), !item.thumbnail.isEmpty {
                    // Display image from API using AsyncImage (iOS 15+)
                    AsyncImage(url: thumbnailUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 76, height: 76)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 76, height: 76)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                                placeholder
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 76, height: 76)
                                    .clipped()
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                            }
                        @unknown default:
                            if let placeholder = ImageLoader.bundleImage(named: Constants.TransactionRowConstants.placeHolderImage) {
                                placeholder
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 76, height: 76)
                                    .clipped()
                                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .bottomLeft]))
                            }
                        }
                    }
                } else if let uiImage = UIImage(named: Constants.TransactionRowConstants.placeHolderImage) {
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
                        Text(item.orderNo)
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
                    if let calendarIcon = ImageLoader.bundleImage(named: Constants.Icons.calendargray) {
                        calendarIcon
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.secondary)
                    }
                    Text(DateFormatter.shortDate.string(from: item.travelDate))
                        .font(.custom("OpenSans-SemiBold", size: 12))
                    Spacer()

                    if let icon = ImageLoader.bundleImage(named: Constants.Icons.usergray) {
                        HStack(spacing: 6) {
                            icon
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.secondary)
                            Text(participantsSummary)
                                .font(.custom("OpenSans-SemiBold", size: 12))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Label(participantsSummary, image: Constants.Icons.usergray)
                            .font(.custom("OpenSans-SemiBold", size: 12))
                    }
                    Spacer()
                }
                
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                if !item.time.isEmpty && item.time != "00:00" {
                    HStack {
                        if let clockIcon = ImageLoader.bundleImage(named: Constants.Icons.clock) {
                            clockIcon
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.secondary)
                        }
                        Text(item.time)
                            .font(.custom("OpenSans-SemiBold", size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
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
                
                Text(getStatusValue())
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

    func getStatusValue() -> String {
        switch item.status {
        case .confirmed,.pending, .completed, .failed:
            return item.status.rawValue.capitalized

        case .cancelled, .refunded:
            return "Cancelled"
        }
    }
}
