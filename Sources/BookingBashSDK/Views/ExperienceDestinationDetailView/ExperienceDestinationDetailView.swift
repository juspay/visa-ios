import SwiftUI

struct ExperienceDestinationDetailView : View {
    @State private var searchText: String = ""
    @State private var isSearchSheetPresented = false
    var experience: Experience
    
    var body: some View {
        ThemeTemplateView(
            needsScroll: true,
            headerHasPadding: false,
            contentHasRoundedCorners: false,
            // MARK: - Header (Top bar + image + Search bar)
            header: {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Dubai")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    // Hero image with floating search bar
                    GeometryReader { proxy in
                        ZStack(alignment: .bottom) {
                            if let destinationImg = ImageLoader.bundleImage(named: "DubaiImage") {
                                destinationImg
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: proxy.size.width, height: 250)
                                    .mask(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .frame(width: proxy.size.width, height: 250)
                                            .padding(.bottom, -16) // keeps bottom corners square
                                    )
                            }

                            // Floating search bar
                            SearchBarView(
                                viewModel: SearchDestinationViewModel(),
                                searchPlaceholderText: "Search Burj Khalifa",
                                searchText: $searchText
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                            .padding(.horizontal, 16)
                            .offset(y: -20)
                            .onTapGesture {
                                withAnimation { isSearchSheetPresented = true }
                            }
                        }
                    }
                    .frame(height: 250)
                }
            },
            
            // MARK: - Content (below white background)
            content: {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // MARK: - "Choose your vibe" section
                    SectionHeaderView(
                        title: "Choose your vibe",
                        showViewAll: false
                    )
                    VStack(spacing: 16) {
                        VibeCardView(
                            imageName: "funPass",
                            title: "Save Big with a Fun Pass"
                        )
                        
                        VibeCardView(
                            imageName: "waterPark",
                            title: "Water Parks & Experiences"
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - "Trending experiences" horizontal scroll
                    SectionHeaderView(
                        title: "Trending experiences",
                        showViewAll: false
                    )
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(sampleExperiences) { exp in
                                ExperienceCardView(
                                    experience: exp,
                                    cardHeight: 220,
                                    cardWidth: 180
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 8)
                    
                    // MARK: - Dubai experiences list
                    ExperienceListDetailView(
                        destinationId: "12633",
                        destinationType: 0,
                        location: "Dubai",
                        checkInDate: "2025-09-26",
                        checkOutDate: "2025-09-27",
                        currency: "AED",
                        productCodes: [],
                        showSearchBar: false,
                        experiences: [
//                            ExperienceListModel(title: "Burj Khalifa Tour", rating: 4.8, reviewCount: 1200, price: 150, imageName: "burjKhalifa", productCode: "BK123", currency: "AED"),
//                            ExperienceListModel(title: "Dubai Desert Safari", rating: 4.7, reviewCount: 950, price: 200, imageName: "desertSafari", productCode: "DDS456", currency: "AED"),
//                            ExperienceListModel(title: "Aquaventure Waterpark", rating: 4.6, reviewCount: 800, price: 180, imageName: "waterPark", productCode: "AW789", currency: "AED")
                        ],
                        useThemeTemplate: false
                    )

//                    .padding(.horizontal, 16) // optional: align with other sections
                    .padding(.top, 8)
                    
//                    Spacer()
                }
                .padding(.top, 20)
            }

        )
    }
}
// Static for now-

let sampleExperiences: [Experience] = [
    Experience(
        imageURL: "Sky",   // bundle image name
        country: "UAE",
        title: "Dubai Red Dunes ATV",
        originalPrice: 350,
        discount: 15,
        finalPrice: 295,
        productCode: "EXP001"
    ),
    Experience(
        imageURL: "DubaiImage",
        country: "UAE",
        title: "Dubai Frame Entry Ticket",
        originalPrice: 320,
        discount: 10,
        finalPrice: 290,
        productCode: "EXP002"
    ),
    Experience(
        imageURL: "Sky",
        country: "UAE",
        title: "Burj Khalifa 124th Floor",
        originalPrice: 450,
        discount: 20,
        finalPrice: 360,
        productCode: "EXP003"
    )
]
