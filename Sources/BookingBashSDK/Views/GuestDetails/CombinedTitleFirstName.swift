import SwiftUI
import SVGKit
import Foundation

struct CombinedTitleFirstName: View {
    let titleOptions: [String]
    @Binding var selectedTitle: String
    @Binding var firstName: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Left: Title menu
            Menu {
                ForEach(titleOptions.filter { $0 != Constants.GuestDetailsFormConstants.title }, id: \ .self) { t in
                    Button(t) {
                        selectedTitle = t
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedTitle)
                        .font(.system(size: 14))
                        .foregroundColor(selectedTitle == Constants.GuestDetailsFormConstants.title ? Color(.systemGray3) : Color(.label))
                    Image(systemName: Constants.GuestDetailsFormConstants.systemNameChevronDown)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.brown))
                }
                .frame(minWidth: 88, maxWidth: 100, alignment: .leading)
                .padding(.leading, 12)
                .padding(.vertical, 12)
            }
            
            // vertical divider
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 1)
            
            // Right: first name textfield (bare style)
            BareTextField(placeholder: Constants.GuestDetailsFormConstants.enterFirstName, text: $firstName)
                .padding(.vertical, 0)
                .padding(.leading, 12)
            
        }
        .frame(height: 44)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
        .cornerRadius(8)
    }
}
