import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToHome = false
    @State private var isHomeActive = true
    @State private var showExitSheet = false
    let encryptPayLoad: String
    var onFinish: () -> Void
    var body: some View {
        NavigationView {
            ThemeTemplateView(
                needsScroll: false,
                headerHasPadding: true,
                contentHasRoundedCorners: true,
                header: {
                },
                content: {
                    ZStack {
                        contentView
                        NavigationLink(
                            destination: ExperienceHomeView(
                                encryptPayLoadMainapp: encryptPayLoad,
                                isActive: $isHomeActive,
                                onFinish: {
                                    navigateToHome = false
                                }
                            ),
                            isActive: $navigateToHome
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    }
                },
                onBack: { showExitSheet = true }
            )
            .skipConfirmationSheet(
                isPresented: $showExitSheet,
                onFinish: onFinish
            )
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("MainAppHomeFinished"))) { _ in
                print("🔵 PrivacyPolicyView received HomeFinished notification - triggering main callback")
                print("Home Finished")
                onFinish()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(spacing: 0) {
            // Centered scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer(minLength: 0)

                    VStack(alignment: .center, spacing: 16) {
                        privacyPolicyContent
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: UIScreen.main.bounds.height * 0.7) // centers content
                    .padding(.horizontal, 20)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
            }

            // Fixed bottom button area
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                acceptButton
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
            }
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
    }

    // MARK: - Privacy Policy Content
    private var privacyPolicyContent: some View {
        VStack(alignment: .center, spacing: 24) {
            if let image = ImageLoader.bundleImage(named: "Sheild") {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .center, spacing: 20) {
                Text("Your privacy is our\nresponsibility")
                    .font(.custom("Lexend-Medium", size: 24))
                    .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Use of Your Personal Data")
                        .font(.custom("Lexend-SemiBold", size: 16))
                        .foregroundColor(Color(hex: Constants.HexColors.blackStrong))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("We'll use your personal data (e.g., name, email) to create an account for BookingBash and send you transactional emails related to your bookings.")
                        .font(.custom("Lexend-Regular", size: 14))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        .lineSpacing(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("By clicking \"I Agree\", you consent to this use of your data.")
                        .font(.custom("Lexend-Regular", size: 14))
                        .foregroundColor(Color(hex: Constants.HexColors.neutral))
                        .lineSpacing(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    // MARK: - Accept Button
    private var acceptButton: some View {
        Button(action: {
            navigateToHome = true
        }) {
            Text("I Agree")
                .font(.custom("Lexend-Medium", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(hex: Constants.HexColors.primaryGold))
                .cornerRadius(8)
        }
    }
}

// MARK: - View Extensions
extension View {
    func skipConfirmationSheet(
        isPresented: Binding<Bool>,
        onFinish: @escaping () -> Void
    ) -> some View {
        overlay(alignment: .bottom) {
            if isPresented.wrappedValue {
                let screenHeight = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                    .screen.bounds.height ?? 0
                BottomSheetView(isPresented: isPresented, sheetHeight: screenHeight * 0.34) {
                    VStack(spacing: 20) {
                        
                        if let activityImage = ImageLoader.bundleImage(named: Constants.Icons.activity) {
                            activityImage
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                        }
                        
                        Text("Are you sure you want to exit?")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                        
                        HStack(spacing: 12) {
                            Button {
                                isPresented.wrappedValue = false
                                onFinish()
                            } label: {
                                Text("Yes, Skip")
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
                                Text("Stay")
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
