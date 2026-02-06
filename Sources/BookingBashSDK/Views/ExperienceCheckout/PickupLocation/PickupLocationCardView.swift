//
//  PickupLocationCardView.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 23/01/26.
//

import SwiftUI

enum PickupLocationType: CaseIterable {
    case likeTobePickedUp
    case makeMyOwnWay
    case decideLater
    
    var title: String {
        switch self {
            
        case .likeTobePickedUp:
            return "I’d like to be picked up"
        case .makeMyOwnWay:
            return "I’ll make my own way to the meeting point"
        case .decideLater:
            return "I’ll decide later"
        }
    }
}

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? Color.brown : Color.gray.opacity(0.5),
                            lineWidth: 2
                        )
                        .frame(width: 20, height: 20)

                    if isSelected {
                        Circle()
                            .fill(Color.brown)
                            .frame(width: 10, height: 10)
                    }
                }

                Text(title)
                    .font(
                        .custom(
                            isSelected
                                ? Constants.Font.openSansSemiBold
                                : Constants.Font.openSansRegular,
                            size: 12
                        )
                    )
                    .foregroundColor(
                        Color(
                            hex: isSelected
                                ? Constants.HexColors.secondary
                                : Constants.HexColors.neutral
                        )
                    )

                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

struct PickupLocationCardView: View {
    let options = PickupLocationType.allCases
    @Binding var selectedOption: PickupLocationType?
//    @Binding var selectedHotel: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Pick up location")
                    .font(.custom(Constants.Font.openSansBold, size: 12))
                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))

                Spacer()

                Button {
                    
                } label: {
                    if let arrowImage = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrowImage
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                }
            }

            Text("Tell us where you’d like to be picked up from. If you're not sure, you can decide later.")
                .font(.custom(Constants.Font.openSansRegular, size: 12))
                .foregroundColor(Color(hex: Constants.HexColors.neutral))

            VStack(spacing: 16) {
                ForEach(options, id: \.self) { option in
                    RadioButton(
                        title: option.title,
                        isSelected: selectedOption == option
                    ) {
                        selectedOption = option
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3))
        )
    }
}

#Preview {
    PickupLocationCardView(selectedOption: .constant(.decideLater))
}
