import SwiftUI

struct GuestDetailsFormView: View {
    @State private var isExpanded = true
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var mobileError: String? = nil
    @Binding var details: GuestDetails
    private let codes = MobileCodeData.allCodes
    
    private let titleMenu = [
        Constants.GuestDetailsFormConstants.title,
        Constants.GuestDetailsFormConstants.mr,
        Constants.GuestDetailsFormConstants.ms,
        Constants.GuestDetailsFormConstants.mrs
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            if isExpanded {
                formSection
            }
        }
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.35)))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            initializeMobileData()
        }
    }
    
    private var headerSection: some View {
        Button {
            withAnimation(.easeInOut) { isExpanded.toggle() }
        } label: {
            HStack(alignment: .center, spacing: 6) {
                if let icon = ImageLoader.bundleImage(named: Constants.Icons.usergray) {
                    icon
                        .resizable()
                        .frame(width: 17, height: 17)
                }
                Text(Constants.GuestDetailsFormConstants.addGuestDetails)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(.label))
                Text(Constants.GuestDetailsFormConstants.requiredMark)
                    .foregroundColor(.red)
                Spacer()
                Image(systemName: isExpanded ? Constants.GuestDetailsFormConstants.systemNameChevronUp : Constants.GuestDetailsFormConstants.systemNameChevronDown)
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(Color(.brown).opacity(0.12))
            .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
        }
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            infoSection
            firstNameSection
            lastNameSection
            emailSection
            mobileSection
        }
        .background(Color.white)
        .padding(.bottom, 20)
    }
    
    private var infoSection: some View {
        Text(Constants.GuestDetailsFormConstants.infoText)
            .font(.system(size: 14))
            .foregroundColor(Color(.systemGray))
            .padding(.horizontal, 14)
            .padding(.top, 6)
    }
    
    private var firstNameSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            requiredLabel(Constants.GuestDetailsFormConstants.firstName)
                .padding(.horizontal, 14)
            CombinedTitleFirstName(
                titleOptions: titleMenu,
                selectedTitle: $details.title,
                firstName: $details.firstName
                
            )
            .padding(.horizontal, 14)
            // Disable only first name field (title remains active)
            .disabled(false) // title dropdown active, name textfield inactive handled internally if needed
        }
    }
    
    private var lastNameSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            requiredLabel(Constants.GuestDetailsFormConstants.lastName)
                .padding(.horizontal, 14)
            StyledTextField(
                placeholder: Constants.GuestDetailsFormConstants.enterLastName,
                text: $details.lastName
            )
            .padding(.horizontal, 14)
             .disabled(true)
             .opacity(0.6)
        }
    }
    
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            requiredLabel(Constants.GuestDetailsFormConstants.email)
                .padding(.horizontal, 14)
            StyledTextField(
                placeholder: Constants.GuestDetailsFormConstants.enterEmail,
                text: $details.email,
                keyboardType: .emailAddress
            )
            .padding(.horizontal, 14)
             .disabled(true)
             .opacity(0.6) 
        }
    }
    
    private var mobileSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            requiredLabel(Constants.GuestDetailsFormConstants.mobile)
                .padding(.horizontal, 14)
            CombinedMobileField(
                codes: codes,
                selectedCode: $details.mobileCountryCode,
                mobile: $details.mobileNumber,
                onCodeChange: {
                    details.mobileNumber = ""
                }
            )
            .padding(.horizontal, 14)
            // Keep this editable (do not disable)
            .onChange(of: details.mobileNumber) { newValue in
                if let selected = codes.first(where: { $0.dialCode == details.mobileCountryCode }) {
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count > selected.maxCharLimit {
                        details.mobileNumber = String(filtered.prefix(selected.maxCharLimit))
                    } else {
                        details.mobileNumber = filtered
                    }
                } else {
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered.count > 7 {
                        details.mobileNumber = String(filtered.prefix(7))
                    } else {
                        details.mobileNumber = filtered
                    }
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func requiredLabel(_ text: String) -> some View {
        HStack(spacing: 2) {
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            Text("*")
                .font(.system(size: 14))
                .foregroundColor(.red)
        }
    }
    
    private func initializeMobileData() {
        // Initialize all fields from profile
        if !profileViewModel.userProfile.firstName.isEmpty {
            details.firstName = profileViewModel.userProfile.firstName
        }
        
        if !profileViewModel.userProfile.lastName.isEmpty {
            details.lastName = profileViewModel.userProfile.lastName
        }
        
        if !profileViewModel.userProfile.email.isEmpty {
            details.email = profileViewModel.userProfile.email
        }
        
        // Set country code from profile
        let apiCountryCode = profileViewModel.userProfile.mobileCountryCode.hasPrefix("+")
        ? profileViewModel.userProfile.mobileCountryCode
        : "+" + profileViewModel.userProfile.mobileCountryCode
        
        if !profileViewModel.userProfile.mobileCountryCode.isEmpty,
           codes.contains(where: { $0.dialCode == apiCountryCode }) {
            details.mobileCountryCode = apiCountryCode
        } else if details.mobileCountryCode.isEmpty {
            details.mobileCountryCode = "+971"
        }
        
        // Set mobile number from profile
        if !profileViewModel.userProfile.mobileNumber.isEmpty {
            details.mobileNumber = profileViewModel.userProfile.mobileNumber
        }
    }
}
