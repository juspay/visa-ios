//
import SwiftUI
import SUINavigation

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @OptionalEnvironmentObject private var navigationStorage: NavigationStorage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ThemeTemplateView(header: {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    if let icon = ImageLoader.bundleImage(named: Constants.Icons.user) {
                        icon
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.white)
                    }
                    Text("My Profile")
                        .font(.custom("Lexend-Bold", size: 16))
                        .foregroundStyle(Color.white)
                }
                .padding(.horizontal, 12)
            }
        }, content: {
            VStack(spacing: 20) {
                // User Profile Card
                ProfileInfoCardView(profile: profileViewModel.userProfile)
                
                // Saved Travelers Section
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Saved Traveler")
//                        .font(.custom(Constants.Font.openSansBold, size: 16))
//                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
//                        .padding(.horizontal, 16)
//                    
//                    VStack(spacing: 12) {
//                        ForEach(Array(profileViewModel.savedTravelers.enumerated()), id: \.element.id) { index, traveler in
//                            SavedTravelerCardView(traveler: traveler) {
//                                profileViewModel.deleteTraveler(at: index)
//                            }
//                            .padding(.horizontal, 16)
//                        }
//                    }
//                }
                
                Spacer(minLength: 100)
            }
            .padding(.top, 20)
        })
        .navigationBarHidden(true)
    }
}
