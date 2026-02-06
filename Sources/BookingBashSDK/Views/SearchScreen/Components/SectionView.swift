

import SwiftUI

struct SectionView: View {
    let title: String
    let showClear: Bool
    let destinations: [SearchDestinationModel]
    let onClear: (() -> Void)?
    let onTap: (SearchDestinationModel) -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(title)
                        .font(.custom(Constants.Font.openSansBold, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                    Spacer()
                    if showClear, let onClear = onClear {
                        Button(Constants.searchScreenConstants.clear, action: onClear)
                            .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                            .foregroundStyle(Color(hex: Constants.HexColors.primary))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 4)

                ForEach(destinations) { destination in
                    Button(action: {
                        onTap(destination)
                    }) {
                        HStack(spacing: 12) {

//                            if let mapImage = ImageLoader.bundleImage(named: Constants.Icons.mapGray) {
//                                mapImage
//                                    .resizable()
//                                    .foregroundColor(.gray)
//                                    .frame(width: 20, height: 20)
//                                    .foregroundStyle(.gray)
//                            }

                            Text(destination.name)
                                .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                                .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))

                            Spacer()

                            if let arrowImage = ImageLoader.bundleImage(named: Constants.Icons.arrowRight) {
                                arrowImage
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if destination.id != destinations.last?.id {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(Color(hex: Constants.HexColors.surfaceWeakest))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(.top, 12)
    }
}
