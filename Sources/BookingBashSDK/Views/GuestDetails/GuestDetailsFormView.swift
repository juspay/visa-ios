//
//  GuestDetailsFormView.swift
//  VisaActivity
//
//  Created by apple on 05/09/25.
//

import SwiftUI

struct GuestDetailsFormView: View {
    @State private var isExpanded = true
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var mobileError: String? = nil
    @Binding var details : GuestDetails
    
    private let codes: [MobileCode] = [
        MobileCode(name: "UAE", maxCharLimit: 9, countryCode: 1, dialCode: "+971", image: "https://d33mtyizv24ggq.cloudfront.net/assets/ae.svg"),
        MobileCode(name: "China", maxCharLimit: 11, countryCode: 2, dialCode: "+86", image: "https://d33mtyizv24ggq.cloudfront.net/assets/cn.svg"),
        MobileCode(name: "Singapore", maxCharLimit: 8, countryCode: 3, dialCode: "+65", image: "https://d33mtyizv24ggq.cloudfront.net/assets/sg.svg"),
        MobileCode(name: "India", maxCharLimit: 10, countryCode: 4, dialCode: "+91", image: "https://d33mtyizv24ggq.cloudfront.net/assets/in.svg"),
        MobileCode(name: "Iceland", maxCharLimit: 7, countryCode: 5, dialCode: "+354", image: "https://d33mtyizv24ggq.cloudfront.net/assets/is.svg")
    ]
    
    // include placeholder "Title" as first element
    private let titleMenu = ["Title", "Mr", "Ms", "Mrs"]
    
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
                            codes: codes,
                            selectedCode: Binding(
                                get: {
                                    // Always use the validated country code to prevent invalid codes
                                    if !details.mobileCountryCode.isEmpty {
                                        return details.mobileCountryCode
                                    } else {
                                        return getValidCountryCode() // This ensures we always return a valid code
                                    }
                                },
                                set: { newValue in
                                    details.mobileCountryCode = newValue
                                    // Update global variable when user changes it
                                    mobileCountryCode = newValue
                                }
                            ),
                            mobile: Binding(
                                get: {
                                    // Priority: 1. User updated value in details, 2. Global variable
                                    if !details.mobileNumber.isEmpty {
                                        return details.mobileNumber
                                    } else if !mobileNumber.isEmpty {
                                        return mobileNumber
                                    } else {
                                        return ""
                                    }
                                },
                                set: { newValue in
                                    details.mobileNumber = newValue
                                    // Update global variable when user changes it
                                    mobileNumber = newValue
                                }
                            ),
                            onCodeChange: {
                                // Clear only local mobile number when country code changes, keep global intact
                                details.mobileNumber = ""
                                // Don't clear mobileNumber global variable
                            }
                        )
                        .padding(.horizontal, 14)
                        .onChange(of: details.mobileNumber) { newValue in
                            // Restrict to the maxCharLimit for the selected country code
                            let currentCode = getCurrentCountryCode()
                            if let selected = codes.first(where: { $0.dialCode == currentCode }) {
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count > selected.maxCharLimit {
                                    details.mobileNumber = String(filtered.prefix(selected.maxCharLimit))
                                    mobileNumber = details.mobileNumber
                                } else {
                                    details.mobileNumber = filtered
                                    mobileNumber = details.mobileNumber
                                }
                            } else {
                                // fallback: default to 10 digits if country not found
                                let filtered = newValue.filter { $0.isNumber }
                                if filtered.count > 10 {
                                    details.mobileNumber = String(filtered.prefix(10))
                                    mobileNumber = details.mobileNumber
                                } else {
                                    details.mobileNumber = filtered
                                    mobileNumber = details.mobileNumber
                                }
                            }
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
        .onAppear {
            // Initialize details with global variables or API response data
            initializeMobileData()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Maps global country code to a valid dropdown option, returns default if not found
    private func getValidCountryCode() -> String {
        let globalCode = mobileCountryCode.isEmpty ? "" : mobileCountryCode
        
        // Check if global country code exists in our dropdown list
        if !globalCode.isEmpty && codes.contains(where: { $0.dialCode == globalCode }) {
            return globalCode // Return the actual global code if it exists in dropdown
        }
        
        // If global code is empty or not found in dropdown, return default UAE
        return "+971"
    }
    
    private func initializeMobileData() {
        // Debug print to see what we're working with
        print("DEBUG: Global mobileCountryCode = '\(mobileCountryCode)'")
        print("DEBUG: Global mobileNumber = '\(mobileNumber)'")
        print("DEBUG: details.mobileCountryCode = '\(details.mobileCountryCode)'")
        print("DEBUG: details.mobileNumber = '\(details.mobileNumber)'")
        
        // Always sync country code from global to local when page appears
        if !mobileCountryCode.isEmpty && codes.contains(where: { $0.dialCode == mobileCountryCode }) {
            details.mobileCountryCode = mobileCountryCode
        } else if details.mobileCountryCode.isEmpty {
            // Only set default if both global and local are empty
            let validCode = getValidCountryCode()
            print("DEBUG: Setting details.mobileCountryCode to '\(validCode)'")
            details.mobileCountryCode = validCode
            mobileCountryCode = validCode
        }
        
        // Always sync mobile number from global to local when page appears
        if !mobileNumber.isEmpty {
            details.mobileNumber = mobileNumber
        }
        
        print("DEBUG: Final details.mobileCountryCode = '\(details.mobileCountryCode)'")
        print("DEBUG: Final details.mobileNumber = '\(details.mobileNumber)'")
    }
    
    private func getCurrentCountryCode() -> String {
        if !details.mobileCountryCode.isEmpty {
            return details.mobileCountryCode
        } else {
            return getValidCountryCode()
        }
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

struct CombinedMobileField: View {
    let codes: [MobileCode]
    @Binding var selectedCode: String
    @Binding var mobile: String
    var onCodeChange: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 0) {
            // Flag + dial code dropdown
            Menu {
                ForEach(codes) { c in
                    Button {
                        if selectedCode != c.dialCode {
                            selectedCode = c.dialCode
                            onCodeChange?()
                        }
                    } label: {
                        HStack {
                            Text(c.dialCode)
                                .foregroundColor(.black)
                        }
                    }
                }
            } label: {
                HStack {
                    if let selected = codes.first(where: { $0.dialCode == selectedCode }),
                       let url = URL(string: selected.image) {
                        // SVGImageView(url: url) removed for now
                    }
                    Text(selectedCode)
                        .foregroundColor(.black)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.brown)
                        .padding(.leading, 1) // Move arrow closer to code text
                    Spacer()
                }
                .padding(.leading, 10)
                .frame(minWidth: 88, maxWidth: 110, alignment: .leading)
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 1)
                .padding(.vertical, 8)
            
            // Mobile number text field
            BareTextField(
                placeholder: "Enter mobile number",
                text: $mobile,
                keyboardType: .numberPad
            )
            .padding(.leading, 12)
        }
        .frame(height: 44)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.35)))
        .cornerRadius(8
        )
    }
}

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
