import SwiftUI

struct ProfileInfoCardView: View {
    let profile: ProfileModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Group {
                    if let userImage = ImageLoader.bundleImage(named: Constants.Icons.usergray) {
                        userImage
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    }
                }
                Text(profile.name)
                    .bold()
                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blueShade))
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                if let envelope = ImageLoader.bundleImage(named: Constants.Icons.frame) {
                    envelope
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                }
                Text(profile.email)
                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                    .bold()
                    .foregroundStyle(Color(hex: Constants.HexColors.blueShade))
            }
            
            HStack(spacing: 12) {
               
                if let mobile = ImageLoader.bundleImage(named: Constants.Icons.mobile) {
                                    mobile
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                                    
                                }
                Text("\(profile.mobileCountryCode) \(profile.mobileNumber)")
                    .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                    .bold()
                    .foregroundStyle(Color(hex: Constants.HexColors.blueShade))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                )
        )
        .padding(.horizontal, 16)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
