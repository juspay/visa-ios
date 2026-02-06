import SwiftUI

struct CombinedMobileField: View {
    let codes: [MobileCode]
    @Binding var showCountryCodeList: Bool
    @Binding var selectedCode: String
    @Binding var mobile: String
    @Binding var showError: Bool
    var onCodeChange: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 6) {
                if let selected = codes.first(where: { $0.dialCode == selectedCode }),
                   let url = URL(string: selected.image) {
                    SVGImageView(url: url)   // Flag based on selectedCode
                        .id(selected.dialCode)
                        .frame(width: 20, height: 14)
                        .aspectRatio(contentMode: .fill)
                        .padding(.leading, 10)
                } else {
                    // Optionally show a default placeholder flag if not found
                    Image(systemName: Constants.GuestDetailsFormConstants.systemNameFlag)
                        .frame(width: 20, height: 14)
                        .scaledToFit()
                        
                }
                Text(selectedCode)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.trailing, 4)
                
                if let arrow = ImageLoader.bundleImage(named: Constants.Icons.arrowDown) {
                    arrow
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: Constants.HexColors.primary))
                }
            }
            .frame(minWidth: 70, maxWidth: 120, alignment: .leading)
            .padding(.leading, 10)
            .onTapGesture {
                showCountryCodeList = true
            }
            
            // Divider
            Rectangle()
                .fill((showError && showErrorHighlight()) ? Color(hex: Constants.HexColors.error) : Color.gray.opacity(0.25))
                .frame(width: 1)
            
            // Mobile number text field
            BareTextField(
                placeholder: Constants.GuestDetailsFormConstants.enterMobileNumber,
                text: $mobile,
                keyboardType: .numberPad
            )
            .padding(.leading, 6)
        }
        .frame(height: 44)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke((showError && showErrorHighlight()) ? Color(hex: Constants.HexColors.error) : Color.gray.opacity(0.35))
        )
        .cornerRadius(8)
    }

    func showErrorHighlight() -> Bool {
        let MobileCode = codes.first(where: { $0.dialCode == selectedCode })
        if mobile.isEmpty || (mobile.count != MobileCode?.maxCharLimit) {
           return true
        }
        return false
    }
}
