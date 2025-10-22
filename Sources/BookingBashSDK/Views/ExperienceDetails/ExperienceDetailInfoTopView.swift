
import SwiftUI

struct ExperienceDetailInfoTopView: View {
    let model: ExperienceDetailModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
//                Text(Constants.DetailScreenConstants.tickets)
//                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                    .foregroundStyle(Color.white)
//
//                Text(model.category)
//                    .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                    .foregroundStyle(Color.white)
                Spacer()
                HStack(spacing: 2) {
//                    if let starImage = ImageLoader.bundleImage(named: Constants.Icons.star) {
//                        starImage
//                            .resizable()
//                            .renderingMode(.template)
//                            .frame(width: 16, height: 16)
//                            .foregroundStyle(Color.white)
//                    }
                    
//                    Text(String(format: "%.1f", model.rating))
//                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
//                        .foregroundStyle(Color.white)
//                    Text("(\(model.reviewCount))")
//                        .foregroundStyle(Color.white)
//                        .font(.custom(Constants.Font.openSansSemiBold, size: 12))
                }
            }
            ExperienceDetailInfoTopLocationView(title: model.title, location: model.location)
        }
        .background(Color(hex: Constants.HexColors.secondary))
    }
}
