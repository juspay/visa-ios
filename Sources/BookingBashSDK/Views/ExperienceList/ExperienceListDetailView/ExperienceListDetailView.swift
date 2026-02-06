import SwiftUI

struct ExperienceListDetailView: View {
    @State private var selectedProductCode: String?
    @State private var selectedCurrency = ""
    @State private var showSortSheet = false
    @State private var listItemTapped = false
    
    // Fix: Add a local state to handle the UI transition gap during sorting
    @State private var isSorting = false

    @StateObject private var viewModel: ExperienceListViewModel
    @StateObject private var sortViewModel: SortViewModel

    let destinationId: String
    let destinationType: Int
    let checkInDate: String
    let checkOutDate: String
    let currency: String
    let productCodes: [String]

    var showSearchBar: Bool = true
    var experiences: [ExperienceListModel]? = nil
    var useThemeTemplate: Bool = true
    var countryName: String = ""
    var navigationToListFromSearch: Bool = false

    init(destinationId: String,
         destinationType: Int,
         checkInDate: String,
         checkOutDate: String,
         currency: String,
         productCodes: [String],
         showSearchBar: Bool = true,
         experiences: [ExperienceListModel]? = nil,
         useThemeTemplate: Bool = true,
         countryName: String = "",
         navigationToListFromSearch: Bool = false) {
        self.destinationId = destinationId
        self.destinationType = destinationType
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.currency = currency
        self.productCodes = productCodes
        self.showSearchBar = showSearchBar
        self.experiences = experiences
        self.useThemeTemplate = useThemeTemplate
        self.countryName = countryName
        self.navigationToListFromSearch = navigationToListFromSearch
        
        let sharedViewModel = ExperienceListViewModel()
        _viewModel = StateObject(wrappedValue: sharedViewModel)
        _sortViewModel = StateObject(wrappedValue: SortViewModel(viewModel: sharedViewModel))
    }
    
    var body: some View {
        Group {
            if useThemeTemplate {
                ThemeTemplateView(header: { MainTopHeaderView(headerText: "") }) {
                    content
                }
            } else {
                content
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigation(isActive: $listItemTapped, id: Constants.NavigationId.experienceDetailView) {
            ExperienceDetailView(productCode: selectedProductCode, currency: selectedCurrency)
        }
        .overlay(
            BottomSheetView(isPresented: $showSortSheet, dismissOnbackgroundClick: true) {
                SortView(viewModel: sortViewModel, onOptionSelected: { showSortSheet = false })
            }
         )
        .onAppearOnce {
            loadExperiences()
        }
    }
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            VStack {
                Spacer()
                LoaderView(text: Constants.ExperienceListDetailViewConstants.loadingExperiences)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else if viewModel.showErrorView {
            VStack {
                NoResultsView()
//                ErrorMessageView()
            }
            .padding(.top, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else {
            experiencesContent
        }
    }
    
    private var displayedExperiences: [ExperienceListModel] {
        if let experienceData = experiences {
            return experienceData
        }
        
        let trimmed = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let source = trimmed.count >= 3 ? viewModel.filteredExperiences : viewModel.experiences
        return source
    }
    
    @ViewBuilder
    private var experiencesContent: some View {
        VStack(spacing: 16) {
            if showSearchBar {
                ExperienceSearchBarView(
                    viewModel: viewModel,
                    searchPlaceholderText: Constants.ExperienceListDetailViewConstants.searchPlaceholder,
                    searchText: $viewModel.searchText
                )
            }
            
            if displayedExperiences.isEmpty {
                NoResultsView()
                    .padding(.top, 120)
            } else {
                experiencesList
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .dismissKeyboardOnTap()
    }

    private var experiencesList: some View {
        VStack(spacing: 16) {
            if navigationToListFromSearch {
                Text(Constants.ExperienceListDetailViewConstants.exploreExperiencesText)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(Constants.ExperienceListDetailViewConstants.exploreExperiencesText + " in " + countryName)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            headerRow

            LazyVStack(spacing: 20) {
                ForEach(displayedExperiences, id: \.productCode) { experience in
                    ExperienceListCardView(experience: experience)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: experience)
                        }
                        .onTapGesture {
                            selectedProductCode = experience.productCode
                            selectedCurrency = experience.currency
                            listItemTapped = true
                        }
                }

                // Loader at bottom when more pages exist
                if viewModel.isLoadingMore {
                    ProgressView()
                        .padding()
                }
            }
        }
    }

    private var headerRow: some View {
        HStack(spacing: 20) {
            HStack(spacing: 6) {
                let displayCount = displayedExperiences.count
                Text("\(displayCount) \(displayCount == 1 ? Constants.ExperienceListDetailViewConstants.experienceFoundSingular : Constants.ExperienceListDetailViewConstants.experienceFoundPlural)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
            Button(action: {
                showSortSheet = true
                UIApplication.shared.endEditing()
            }) {
                HStack(spacing: 4) {
                    Text(Constants.ExperienceListDetailViewConstants.sortText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Image(systemName: Constants.ExperienceListDetailViewConstants.chevronDown)
                        .font(.caption)
                        .foregroundColor(Color(hex: Constants.HexColors.primary))
                }
            }
        }
    }

    private func loadExperiences() {
        if let experienceData = experiences {
            viewModel.experiences = experienceData
//            print("[UI] Using injected experiences (count=\(experienceData.count)); pagination disabled")
        } else {
            // Use paginated fetch
//            print("[UI] Trigger paginated resetAndFetch")
            viewModel.resetAndFetch(
                destinationId: destinationId,
                destinationType: destinationType,
                checkInDate: checkInDate,
                checkOutDate: checkOutDate,
                currency: currency,
                productCodes: productCodes
            )
        }
    }
}

// Ensure ExperienceSearchBarView is defined as per your original code
struct ExperienceSearchBarView: View {
    @ObservedObject var viewModel: ExperienceListViewModel
    let searchPlaceholderText: String
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: 8) {
            if let searchImage = ImageLoader.bundleImage(named: Constants.Icons.searchIcon) {
                searchImage
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(hex: Constants.HexColors.primary))
            }
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(searchPlaceholderText)
                        .font(.custom(Constants.Font.openSansRegular, size: 14))
                        .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
                }
                TextField("", text: $searchText)
                    .font(.custom(Constants.Font.openSansRegular, size: 14))
                    .foregroundStyle(Color(hex: Constants.HexColors.blackStrong))
            }
            Spacer()
            // Show X only when user typed something
            if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Image(systemName: Constants.Icons.xmark)
                    .imageScale(.small)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(hex: Constants.HexColors.neutral))
                    .onTapGesture {
                        searchText = ""
                        viewModel.searchText = ""
                    }
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: searchText)
            }
        }
        .onChange(of: searchText) { newValue in
            viewModel.searchText = newValue.drop(while: { $0.isWhitespace }).description
        }
        .frame(height: 44)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}
