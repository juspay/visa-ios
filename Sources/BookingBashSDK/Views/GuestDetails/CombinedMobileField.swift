import SwiftUI

struct CombinedMobileField: View {
    let codes: [MobileCode]
    @Binding var selectedCode: String
    @Binding var mobile: String
    var onCodeChange: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            // Flag + country name + dial code dropdown
            Menu {
                ForEach(codes) { c in
                    Button {
                        if selectedCode != c.dialCode {
                            selectedCode = c.dialCode
                            onCodeChange?()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if let url = URL(string: c.image) {
                                SVGImageView(url: url)
                                    .frame(width: 24, height: 16)
                                    .aspectRatio(contentMode: .fit)
                            }
                            Text("\(c.name) (\(c.dialCode))")
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) { // reduced spacing between country code and arrow
                    if let selected = codes.first(where: { $0.dialCode == selectedCode }),
                       let url = URL(string: selected.image) {
                        SVGImageView(url: url)   // Flag based on selectedCode
                            .id(selected.dialCode)
                            .frame(width: 20, height: 14)
                            .aspectRatio(contentMode: .fill)
                    } else {
                        // Optionally show a default placeholder flag if not found
                        Image(systemName: Constants.GuestDetailsFormConstants.systemNameFlag)
                            .frame(width: 20, height: 14)
                            .scaledToFit()
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
