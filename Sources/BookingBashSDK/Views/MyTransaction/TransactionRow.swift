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
    private func createSavingsText(originalPrice: Double, discountedPrice: Double, currency: String) -> String {
        let savingsAmount = originalPrice - discountedPrice
//        let savingsPercentage = (savingsAmount / originalPrice) * 100
        
        return "You are saving \(savingsAmount) \(currency)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top: image + title + ids
            HStack(alignment: .top, spacing: 12) {
                Image("dubaiParks")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 76, height: 76)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.productTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 4) {
                        Text("Booking ID:")
                            .foregroundColor(.secondary)
                        Text(item.bookingRef)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .font(.subheadline)
                    
                    Text("Booking Date: \(DateFormatter.shortDate.string(from: item.bookingDate))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Middle: date/time + travellers + (optional savings)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Label(DateFormatter.shortDate.string(from: item.travelDate), systemImage: "calendar")
                    Spacer(minLength: 12)
                    Label(item.travellerText, systemImage: "person.2")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Label(item.timeText, systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                // Show savings text using real price data when available
                if let strikeout = item.price.strikeout {
                    HStack {
                        Label(createSavingsText(originalPrice: strikeout.totalAmount, discountedPrice: item.price.totalAmount, currency: item.price.currency), systemImage: "tag")
                            .foregroundColor(.green)
                            .font(.subheadline)
                      
                        Spacer()
                    }
                }

            }
            
            // Bottom:
            HStack {
                Spacer()
                Text("Status")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
//                Spacer()
                Text(item.status.rawValue)
                    .font(.subheadline).bold()
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background(item.status.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .contentShape(Rectangle())
    }
}
