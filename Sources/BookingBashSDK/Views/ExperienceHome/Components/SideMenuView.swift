import SwiftUI

enum MenuItems: CaseIterable, Identifiable {
    case profile
    case transactions
    case currency

    var id: Self { self }

    var imageName: String {
        switch self {
        case .profile:
            return Constants.Icons.usergray
        case .transactions:
            return Constants.Icons.activity
        case .currency:
            return Constants.Icons.currencyWhite
        }
    }

    var title: String {
        switch self {
        case .profile:
            return Constants.SideMenuConstants.myProfile
        case .transactions:
            return Constants.SideMenuConstants.myTransactions
        case .currency:
            return Constants.SideMenuConstants.currency
        }
    }

    @ViewBuilder
    func destination(viewModel: HomeViewModel) -> some View {
        switch self {
        case .profile:
            ProfileView()
        case .transactions:
            MyTransactionView(homeViewModel: viewModel)
        case .currency:
            CurrencyListView(viewModel: viewModel)
        }
    }
}

struct SideMenuView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {

                // Profile Section
                HStack(spacing: 6) {
                    if let profileImage = ImageLoader.bundleImage(
                        named: Constants.SideMenuConstants.iconProfile
                    ) {
                        profileImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

                    Text(String(
                        format: Constants.SideMenuConstants.greetingText,
                        firstName
                    ))
                    .lineLimit(1)
                    .font(.custom(Constants.Font.lexendBold, size: 14))
                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                }
                .padding(.top, 40)
                .padding(.horizontal, 20)

                // Menu Items
                VStack(spacing: 8) {
                    ForEach(MenuItems.allCases) { item in
                        NavigationLink(destination: item.destination(viewModel: viewModel)) {
                            MenuRow(
                                icon: item.imageName,
                                title: item.title
                            )
                        }
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
                .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
            
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
        .padding(14)
        .background(Color(hex: Constants.HexColors.surfaceWeakest))
        .cornerRadius(12)
    }
}
