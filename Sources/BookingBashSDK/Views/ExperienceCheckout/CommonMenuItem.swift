//
//  CommonMenuItem.swift
//  VisaActivity
//
//  Created by Pranoti Wakodkar on 23/01/26.
//

import SwiftUI

struct CommonMenuItem: View {
    let title: String
    let placeholder: String
    let options: [String]
    @Binding var selectedOption: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Title
            Text(title)
                .font(.custom(Constants.Font.openSansBold, size: 12))
                .foregroundColor(Color(hex: Constants.HexColors.blackStrong))

            // Menu
            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selectedOption = option
                    } label: {
                        Text(option)
                            .font(.custom(Constants.Font.openSansRegular, size: 12))
                            .foregroundColor(Color(hex: Constants.HexColors.secondary))
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption.isEmpty ? placeholder : selectedOption)
                        .font(.custom(Constants.Font.openSansRegular, size: 12))
                        .foregroundColor(
                            selectedOption.isEmpty
                            ? Color.gray
                            : Color(hex: Constants.HexColors.secondary)
                        )

                    Spacer()

                    if let arrowImage = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrowImage
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    CommonMenuItem(
        title: "Gender",
        placeholder: "Select",
        options: ["Male", "Female", "Other"],
        selectedOption: .constant("")
    )
}
