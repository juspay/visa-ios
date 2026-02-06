import SwiftUI
import SVGKit
import Foundation

struct CombinedTitleFirstName: View {
    let titleOptions: [String]
    @Binding var selectedTitle: String
    @Binding var firstName: String
    @Binding var showError: Bool

    private var filteredTitles: [String] {
        titleOptions.filter { $0 != Constants.GuestDetailsFormConstants.title }
    }

    var body: some View {
        HStack(spacing: 0) {

            // MARK: - Title Menu
            Menu {
                ForEach(filteredTitles, id: \.self) { t in
                    Button {
                        selectedTitle = t
                        UserDefaultsManager.shared.set(t, for: UserDefaultsKey.salutationTitle.rawValue)
                    } label: {
                        Text(t)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(
                        selectedTitle.isEmpty
                        ? Constants.GuestDetailsFormConstants.title
                        : selectedTitle
                    )
                    .font(.system(size: 14))
                    .foregroundColor(
                        selectedTitle.isEmpty
                        ? Color(.systemGray3)
                        : Color(.label)
                    )

                    Spacer()

                    if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                        arrow
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(hex: Constants.HexColors.primary))
                    }
                }
                .frame(minWidth: 88, maxWidth: 100, alignment: .leading)
                .padding(10)
            }

            // MARK: - Divider
            Rectangle()
                .fill(
                    (showError && selectedTitle.isEmpty)
                    ? Color(hex: Constants.HexColors.error)
                    : Color.gray.opacity(0.25)
                )
                .frame(width: 1)

            // MARK: - First Name Field
            BareTextField(
                placeholder: Constants.GuestDetailsFormConstants.enterFirstName,
                text: $firstName
            )
            .disabled(true)
            .opacity(0.6)
            .padding(.leading, 12)
        }
        .frame(height: 44)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    (showError && selectedTitle.isEmpty)
                    ? Color(hex: Constants.HexColors.error)
                    : Color.gray.opacity(0.35)
                )
        )
        .cornerRadius(8)
        .onAppear {
            if selectedTitle.isEmpty,
               let savedTitle: String = UserDefaultsManager.shared.get(for: UserDefaultsKey.salutationTitle.rawValue) {
                selectedTitle = savedTitle
            }
        }
    }
}
