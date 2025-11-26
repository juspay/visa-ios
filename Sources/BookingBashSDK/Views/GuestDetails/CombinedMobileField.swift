import SwiftUI

struct CombinedMobileField: View {
    let codes: [MobileCode]
    @Binding var showCountryCodeList: Bool
    @Binding var selectedCode: String
    @Binding var mobile: String
    var onCodeChange: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 4) { // reduced spacing between country code and arrow
                if let selected = codes.first(where: { $0.dialCode == selectedCode }),
                   let url = URL(string: selected.image) {
                    SVGImageView(url: url)   // Flag based on selectedCode
                        .id(selected.dialCode)
                        .frame(width: 20, height: 14)
                        .aspectRatio(contentMode: .fill)
                        .padding(.leading, 4)
                } else {
                    // Optionally show a default placeholder flag if not found
                    Image(systemName: Constants.GuestDetailsFormConstants.systemNameFlag)
                        .frame(width: 20, height: 14)
                        .scaledToFit()
                        .padding(.leading, 4)
                }
                Text(selectedCode)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.trailing, 5)
                Image(systemName: Constants.GuestDetailsFormConstants.systemNameChevronDown)
                    .foregroundColor(.brown)
                    .padding(.leading, 2)
            }
            .padding(.leading, 0)
            .frame(minWidth: 70, maxWidth: 120, alignment: .leading)
            .onTapGesture {
                showCountryCodeList = true
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 1)
                .padding(.vertical, 8)
            
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
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
        .cornerRadius(8)
    }
}
