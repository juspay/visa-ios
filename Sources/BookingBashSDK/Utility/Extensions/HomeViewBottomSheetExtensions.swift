import SwiftUI

// MARK: - Search Sheet
extension View {
    func searchSheet(
        isPresented: Binding<Bool>,
        destinations: [Destination],
        searchDestinationViewModel: SearchDestinationViewModel,
        onSelectDestination: @escaping (SearchRequestModel) -> Void
    ) -> some View {
        overlay {
            if isPresented.wrappedValue {
                let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                    .screen.bounds.height ?? 0
                BottomSheetView(isPresented: isPresented, sheetHeight: screenHeight * 0.9) {
                    SearchDestinationBottomSheetView(
                        searchDestinationViewModel: searchDestinationViewModel,
                        destinations: destinations,
                        isPresented: isPresented,
                        onSelectDestination: onSelectDestination
                    )
                }
            }
        }
        .onAppear {
            searchDestinationViewModel.searchText = ""
            searchDestinationViewModel.destinations.removeAll()
        }
    }

    func searchCountryCodeSheet(isPresented: Binding<Bool>,
                                countries: [MobileCode],
                                onCountryCodeSelection: @escaping (MobileCode?) -> Void)  -> some View  {
        overlay {
            if isPresented.wrappedValue {
                let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                    .screen.bounds.height ?? 0
                
                BottomSheetView(isPresented: isPresented, sheetHeight: screenHeight * 0.9) {
                    SearchCountryBottomSheetView(countries: countries,
                                                 isPresented: isPresented,
                                                 onSelectCode: onCountryCodeSelection)
                }
            }
        }
    }
}

// MARK: - Skip Confirmation Sheet
extension View {
    func skipConfirmationSheet(
        isPresented: Binding<Bool>,
        isActive: Binding<Bool>,
        onFinish: @escaping () -> Void
    ) -> some View {
        overlay(alignment: .bottom) {
            if isPresented.wrappedValue {
                GeometryReader { geometry in
                    let screenHeight = geometry.size.height
                    BottomSheetView(isPresented: isPresented, sheetHeight: screenHeight * 0.34) {
                        VStack(spacing: 20) {
                            if let activityImage = ImageLoader.bundleImage(named: Constants.Icons.activity) {
                                activityImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                            }

                            Text(Constants.HomeScreenConstants.cancelBookingText)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)

                            HStack(spacing: 12) {
                                Button {
                                    isPresented.wrappedValue = false
                                    isActive.wrappedValue = false
                                    onFinish()
                                } label: {
                                    Text(Constants.HomeScreenConstants.skip)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(hex: Constants.HexColors.primary))
                                        .frame(width: 120, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(hex: Constants.ColorConstants.strokeColor), lineWidth: 2)
                                        )
                                }

                                Button {
                                    isPresented.wrappedValue = false
                                } label: {
                                    Text(Constants.HomeScreenConstants.stay)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(hex: Constants.ColorConstants.fillColor))
                                        )
                                }
                            }
                            .frame(maxWidth: 260)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 25)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
}

// MARK: - Privacy Policy Sheet
extension View {
    func privacyPolicySheet(
        isPresented: Binding<Bool>,
        onAgree: @escaping () -> Void,
        onDisAgree: @escaping () -> Void
    ) -> some View {
        overlay(alignment: .bottom) {
            if isPresented.wrappedValue {
                GeometryReader { _ in
                    let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                        .screen.bounds.height ?? 0

                    BottomSheetView(
                        isPresented: isPresented,
                        content: {
                            VStack(spacing: 0) {
                                if let policyImage = ImageLoader.bundleImage(named: Constants.Icons.sheild) {
                                    policyImage
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48)
                                        .padding(.top, 16)
                                }

                                Text(Constants.PrivacyPolicyConstants.title)
                                    .font(.custom(Constants.Font.lexendMedium, size: 18))
                                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)

                                VStack(alignment: .center, spacing: 8) {
                                    Text(Constants.PrivacyPolicyConstants.useOfPersonalData)
                                        .font(.custom(Constants.Font.lexendMedium, size: 14))
                                        .foregroundColor(.black)
                                    Text(Constants.PrivacyPolicyConstants.personalDataDescription)
                                        .font(.custom(Constants.Font.lexendMedium, size: 14))
                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Text(Constants.PrivacyPolicyConstants.consentText)
                                        .font(.custom(Constants.Font.lexendMedium, size: 14))
                                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                                .padding(.bottom, 12)

                                Divider()

                                HStack(spacing: 16) {
                                    Button {
                                        isPresented.wrappedValue = false
                                        onDisAgree()
                                    } label: {
                                        Text(Constants.PrivacyPolicyConstants.exitButton)
                                            .font(.custom(Constants.Font.lexendMedium, size: 16))
                                            .foregroundColor(Color(hex: Constants.HexColors.primary))
                                            .frame(maxWidth: .infinity, minHeight: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color(hex: Constants.ColorConstants.strokeColor), lineWidth: 2)
                                            )
                                    }

                                    Button {
                                        isPresented.wrappedValue = false
                                        onAgree()
                                    } label: {
                                        Text(Constants.PrivacyPolicyConstants.agreeButton)
                                            .font(.custom(Constants.Font.lexendMedium, size: 16))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, minHeight: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(hex: Constants.ColorConstants.fillColor))
                                            )
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 4)
                                .padding(.top, 12)
                            }
                            .padding(.horizontal, 25)
                            .background(Color.white)
                            .cornerRadius(20)
                            .highPriorityGesture(DragGesture())
                            .frame(maxHeight: .infinity, alignment: .top)
                        },
                        productCode: nil,
                        isDragToDismissEnabled: false
                    )
                }
            }
        }
    }
}
