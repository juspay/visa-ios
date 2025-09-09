//
//  GuestDetailsFormView.swift
//  VisaActivity
//
//  Created by Sakshi on 05/09/25.
//

import SwiftUI

struct GuestDetailsFormView: View {
    @State private var isExpanded = true
//    @State private var details = GuestDetails()
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var mobileError: String? = nil
    @Binding var details : GuestDetails

    
    // include placeholder "Title" as first element
    private let titleMenu = ["Title", "Mr", "Ms", "Mrs"]
    // mobile codes
    private let mobileCodes: [(flag: String, code: String)] = [
        ("🇮🇳", "+91"),
        ("🇺🇸", "+1"),
        ("🇬🇧", "+44"),
        ("🇦🇪", "+971")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header (beige) - top corners rounded only
            Button {
                withAnimation(.easeInOut) { isExpanded.toggle() }
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 18))
                        .foregroundColor(Color(.systemGray))
                    Text("Add Guest Details")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label)) // dark text like ref
                    Text("*").foregroundColor(.red)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 16))
                        .foregroundColor(Color(.systemGray))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(Color(.systemYellow).opacity(0.16))
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 18) {
                    // short description
                    Text("We'll use this information to send you confirmation and updates about your booking.")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                        .padding(.horizontal, 14)
                        .padding(.top, 6)
                    
                    // First name combined (Title + Firstname)
                    VStack(alignment: .leading, spacing: 6) {
                        requiredLabel("First name")
                            .padding(.horizontal, 14)
                        
                        CombinedTitleFirstName(
                            titleOptions: titleMenu,
                            selectedTitle: $details.title,
                            firstName: .constant(profileViewModel.userProfile.firstName)
                        )
                        .disabled(true)
                        .padding(.horizontal, 14)
                    }
                    
                    // Last name (full width)
                    VStack(alignment: .leading, spacing: 6) {
                        requiredLabel("Last name")
                            .padding(.horizontal, 14)
                        StyledTextField(placeholder: "Enter last name", text: .constant(profileViewModel.userProfile.lastName))
                            .disabled(true)
                            .padding(.horizontal, 14)
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        requiredLabel("Email")
                            .padding(.horizontal, 14)
                        StyledTextField(placeholder: "Enter email id", text: .constant(profileViewModel.userProfile.email) , keyboardType: .emailAddress)
                            .disabled(true)
                            .padding(.horizontal, 14)
                    }
                    
                    // Mobile combined (flag + code + number)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        requiredLabel("Mobile")
                            .padding(.horizontal, 14)
                        
                        CombinedMobileField(
                            codes: mobileCodes,
                            selectedCode: $details.countryCode,
                            mobile: $details.mobile
                        )
                        .padding(.horizontal, 14)
                        .onChange(of: details.mobile) { newValue in
                            // restrict to 10 digits only
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered.count > 7 {
                                details.mobile = String(filtered.prefix(7))
                            } else {
                                details.mobile = filtered
                            }
                        }
                        
                        if let error = mobileError {
                            Text(error)
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                                .padding(.horizontal, 14)
                        }
                    }
                    
                    // Save traveler (checkbox)
                    HStack {
                        Checkbox(isOn: $details.saveTravelerDetails)
                        Text("Save traveler details")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 6)
                    
                    // Special Request
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Special Request if any (optional)")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        TextEditor(text: $details.specialRequest)
                            .frame(height: 90)
                            .padding(8)
                            .background(Color.white)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                }
                .background(Color.white)
            }
        }
        // outer card: rounded with stroke and subtle shadow
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.35)))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Helper
    private func requiredLabel(_ text: String) -> some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            Text("*").foregroundColor(.red)
            Spacer()
        }
    }
}

// MARK: - Combined Title + FirstName (shared rounded border, vertical divider)
private struct CombinedTitleFirstName: View {
    let titleOptions: [String]
    @Binding var selectedTitle: String
    @Binding var firstName: String
    
    var body: some View {
        HStack(spacing: 0) {
            // Left: Title menu
            Menu {
                ForEach(titleOptions.filter { $0 != "Title" }, id: \.self) { t in
                    Button(t) {
                        selectedTitle = t
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(selectedTitle)
                        .font(.system(size: 14))
                        .foregroundColor(selectedTitle == "Title" ? Color(.systemGray3) : Color(.label))
                    Image(systemName: "chevron.down")
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
            BareTextField(placeholder: "Enter first name", text: $firstName)
                .padding(.vertical, 0)
                .padding(.leading, 12)
            
        }
        .frame(height: 44)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
        .cornerRadius(8)
    }
}

// MARK: - Combined Mobile Field (flag+code + divider + mobile number)
private struct CombinedMobileField: View {
    let codes: [(flag: String, code: String)]
    @Binding var selectedCode: String
    @Binding var mobile: String
    
    var body: some View {
        HStack(spacing: 0) {
            // flag + code menu
            Menu {
                ForEach(codes, id: \.code) { c in
                    Button {
                        selectedCode = c.code
                    } label: {
                        Label {
                            Text(c.code)
                                .foregroundColor(.gray)
                        } icon: {
                            Text(c.flag)
                        }
                    }
                }
            } label: {
                    HStack(spacing: 8) {
                        // show flag for current code (or fallback)
                        Text(codes.first(where: { $0.code == selectedCode })?.flag ?? "🇮🇳")
                            .foregroundStyle(Color.gray)
                        Text(selectedCode)
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)
                        Image(systemName: "chevron.down").foregroundColor(Color(.brown))
                    }
                    .padding(.leading, 12)
                    .frame(minWidth: 88, maxWidth: 110, alignment: .leading)
                }
            
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 1)
                .padding(.vertical, 8)
            
            BareTextField(placeholder: "Enter mobile number", text: $mobile, keyboardType: .numberPad)
                .padding(.leading, 12)
        }
        .frame(height: 44)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
        .cornerRadius(8)
    }
}

// MARK: - Styled full width TextField (used for last name, email)
private struct StyledTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
            .cornerRadius(8)
            .frame(height: 44)
    }
}

// MARK: - Bare textfield (no outer stroke) used inside combined inputs
private struct BareTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding(.vertical, 12)
            .padding(.trailing, 12)
            .background(Color.white)
    }
}

// MARK: - Checkbox
private struct Checkbox: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Button {
            withAnimation { isOn.toggle() }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.45), lineWidth: 1.5)
                    .frame(width: 22, height: 22)
                    .background(isOn ? Color(.systemBlue).opacity(0.15) : Color.clear)
                if isOn {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.systemBlue))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

