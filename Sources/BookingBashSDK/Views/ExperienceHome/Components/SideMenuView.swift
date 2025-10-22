import SwiftUI

struct SideMenuView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Profile Section
                HStack(spacing: 12) {
                    
                    Group {
                        if let profileImage = ImageLoader.bundleImage(named: Constants.SideMenuConstants.iconProfile) {
                            profileImage
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    Text(String(format: Constants.SideMenuConstants.greetingText, firstName))
                        .font(.custom(Constants.Font.lexendBold, size: 14))
                        .foregroundColor(.black)
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)
                
                // Menu Items
                VStack(spacing: 16) {
                    //  Navigate to MyTransactionView
                    NavigationLink(destination: MyTransactionView()) {
                        MenuRow(icon: Constants.Icons.activity, title: Constants.SideMenuConstants.myTransactions)
                    }
                    
//                    MenuRow(icon: Constants.Icons.savingGray, title: Constants.SideMenuConstants.myBBProSavings )
//                    
//                    MenuRow(icon: Constants.Icons.wishlist, title: Constants.SideMenuConstants.myFavorites)
                    NavigationLink(destination: ProfileView()) {
                        MenuRow(icon: Constants.Icons.usergray, title: Constants.SideMenuConstants.myProfile)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Group {
                if let iconImage = ImageLoader.bundleImage(named: icon) {
                    iconImage
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                }
            }
            
            Text(title)
                .font(.custom(Constants.Font.openSansSemiBold, size: 14))
                .foregroundColor(.black)
            
            Spacer()
            
            Group {
                if let chevronImage = ImageLoader.bundleImage(named: Constants.Icons.arrowRight) {
                    chevronImage
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
}
