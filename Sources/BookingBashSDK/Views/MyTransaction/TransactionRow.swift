//
//  TransactionRow.swift
//  VisaActivity
//
//  Created by praveen on 04/09/25.
//
import SwiftUI

// MARK: - Row (card)

struct TransactionRow: View {
    let item: Booking
    
    // MARK: - Savings Text Function
    private func createSavingsText(originalPrice: Double, discountedPrice: Double, currency: String) -> AttributedString {
        let savingsAmount = originalPrice - discountedPrice
        var text = AttributedString("You are saving ")
        text.foregroundColor = .gray  //  normal text in black
        
        var value = AttributedString("\(Int(savingsAmount)) \(currency)")
        value.foregroundColor = .green
        value.font = .system(size: 14, weight: .bold) //  bold green
        text.append(value)
        return text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // Top: image + title + booking details
            HStack(alignment: .top, spacing: 12) {
                
                if let uiImage = UIImage(named: "PlaceHolderImage") {
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
                                           Image(systemName: "photo")
                                               .font(.system(size: 24))
                                               .foregroundColor(.gray)
                                       )
                               }
                               
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.productTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text("Booking ID:")
                            .foregroundColor(.black)
                        Text(item.bookingRef)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .font(.subheadline)
                    
                    HStack(spacing: 4) {
                        Text("Booking Date:")
                            .foregroundColor(.black)
                        Text(DateFormatter.shortDate.string(from: item.bookingDate))
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)
                }
            }
            
            Divider()
            
            // Middle: travel date, participants, time, savings
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Label(DateFormatter.shortDate.string(from: item.travelDate), systemImage: "calendar")
                    Spacer()
                    Label(item.travellerText, image : "User")
                }
                
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Label(item.timeText, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let strikeout = item.price.strikeout {
                    Label {
                        Text(createSavingsText(
                            originalPrice: strikeout.totalAmount,
                            discountedPrice: item.price.totalAmount,
                            currency: item.price.currency
                        ))
                    } icon: {
                        Image("SavingIcon") // 💰 style icon
                            .resizable()
                            .frame(width: 27, height: 27)
                    }
                    
                }
            }
            
            // Bottom: Status
            HStack {
                Spacer()
                Text("Status")
                    .font(.subheadline)
                    .foregroundColor(.gray) // 🔹 black, not gray
                
                Text(item.status.rawValue.capitalized)
                    .font(.subheadline).bold()
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(item.status.color)
                    .foregroundColor(.white)
                    .cornerRadius(6)  // 🔹 compact like reference
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
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}



//struct TransactionRow: View {
//    let item: Booking
//
//    // MARK: - Savings Text Function
//    private func createSavingsText(originalPrice: Double, discountedPrice: Double, currency: String) -> String {
//        let savingsAmount = originalPrice - discountedPrice
//
//        return "You are saving \(savingsAmount) \(currency)"
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            // Top: image + title + ids
//            HStack(alignment: .top, spacing: 12) {
//                Image("dubaiParks")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 76, height: 76)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//
//                VStack(alignment: .leading, spacing: 6) {
//                    Text(item.productTitle)
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.primary)
//                        .lineLimit(2)
//                        .multilineTextAlignment(.leading)
//
//                    HStack(spacing: 4) {
//                        Text("Booking ID:")
//                            .foregroundColor(.secondary)
//                        Text(item.id)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                    }
//                    .font(.subheadline)
//
//                    Text("Booking Date: \(DateFormatter.shortDate.string(from: item.bookingDate))")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//
//            Divider()
//
//            // Middle: date/time + travellers + (optional savings)
//            VStack(alignment: .leading, spacing: 10) {
//                HStack {
//                    Label(DateFormatter.shortDate.string(from: item.travelDate), systemImage: "calendar")
//                    Spacer(minLength: 12)
//                    Label(item.travellerText, systemImage: "person.2")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                }
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//
//                HStack {
//                    Label(item.timeText, systemImage: "clock")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    Spacer()
//                }
//
//                // Show savings text using real price data when available
//                if let strikeout = item.price.strikeout {
//                    HStack {
//                        Label(createSavingsText(originalPrice: strikeout.totalAmount, discountedPrice: item.price.totalAmount, currency: item.price.currency), systemImage: "tag")
//                            .foregroundColor(.green)
//                            .font(.subheadline)
//
//                        Spacer()
//                    }
//                }
//
//            }
//
//            // Bottom:
//            HStack {
//                Spacer()
//                Text("Status")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//
//                Text(item.status.rawValue)
//                    .font(.subheadline).bold()
//                    .padding(.vertical, 6)
//                    .padding(.horizontal, 14)
//                    .background(item.status.color)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//
//            }
//        }
//        .padding(14)
//        .background(
//            RoundedRectangle(cornerRadius: 14)
//                .fill(Color.white)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 14)
//                        .stroke(Color(.systemGray4), lineWidth: 1)
//                )
//                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
//        )
//        .contentShape(Rectangle())
//    }
//}
