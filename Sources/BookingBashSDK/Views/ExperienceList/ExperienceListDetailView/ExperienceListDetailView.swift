import SwiftUI

struct ExperienceListDetailView: View {
    @State private var selectedProductCode: String?
    @State private var selectedCurrency = ""
    @State private var showSortSheet = false
    @State private var listItemTapped = false
    @State private var scrollToTopTrigger = false

    @StateObject private var viewModel: ExperienceListViewModel
    @StateObject private var sortViewModel: SortViewModel
    
    let destinationId: String
    let destinationType: Int
    let location: String
    let checkInDate: String
    let checkOutDate: String
    let currency: String
    let productCodes: [String]
    
    var showSearchBar: Bool = true
    var experiences: [ExperienceListModel]? = nil
    var useThemeTemplate: Bool = true
    
    init(destinationId: String,
         destinationType: Int,
         location: String,
         checkInDate: String,
         checkOutDate: String,
         currency: String,
         productCodes: [String],
         showSearchBar: Bool = true,
         experiences: [ExperienceListModel]? = nil,
         useThemeTemplate: Bool = true) {
        self.destinationId = destinationId
        self.destinationType = destinationType
        self.location = location
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.currency = currency
        self.productCodes = productCodes
        self.showSearchBar = showSearchBar
        self.experiences = experiences
        self.useThemeTemplate = useThemeTemplate
        
        let sharedViewModel = ExperienceListViewModel()
        _viewModel = StateObject(wrappedValue: sharedViewModel)
        _sortViewModel = StateObject(wrappedValue: SortViewModel(viewModel: sharedViewModel))
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if useThemeTemplate {
                    ThemeTemplateView(needsScroll: false,
                                      header: { MainTopHeaderView(headerText: "") }) {
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
                BottomSheetView(isPresented: $showSortSheet) {
                    SortView(viewModel: sortViewModel, onOptionSelected: { showSortSheet = false })
                }
            )
            .onAppear(perform: loadExperiences)
            
//            Button {
//                scrollToTopTrigger.toggle()
//            } label: {
//                Image(systemName: "arrowshape.up.circle")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(.yellow)
//                    .padding()
//            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading || sortViewModel.isLoading {
            VStack {
                Spacer()
                LoaderView(text: Constants.ExperienceListDetailViewConstants.loadingExperiences)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        else if viewModel.showErrorView {
            VStack {
                ErrorMessageView()
            }
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
                    .padding(.top, 100)
            } else {
                experiencesList
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var experiencesList: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // MARK: – Top anchor for scrolling
                    Color.clear
                        .frame(height: 0)
                        .id("SCROLL_TO_TOP")

                    Text(Constants.ExperienceListDetailViewConstants.exploreExperiencesText)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)

                    headerRow

                    LazyVStack(spacing: 20) {
                        ForEach(displayedExperiences, id: \.productCode) { experience in
                            ExperienceListCardView(experience: experience)
                                .onTapGesture {
                                    selectedProductCode = experience.productCode
                                    selectedCurrency = experience.currency
                                    listItemTapped = true
                                }
                        }
                    }
                }
            }
            .onChange(of: scrollToTopTrigger) { _ in
                // Whenever `scrollToTopTrigger` changes, scroll to top
                withAnimation(.easeInOut) {
                    proxy.scrollTo("SCROLL_TO_TOP", anchor: .top)
                }
            }
        }
    }

    private var headerRow: some View {
        HStack {
            HStack(spacing: 6) {
                let displayCount = displayedExperiences.count
                Text("\(displayCount) \(displayCount == 1 ? Constants.ExperienceListDetailViewConstants.experienceFoundSingular : Constants.ExperienceListDetailViewConstants.experienceFoundPlural)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            Button(action: { showSortSheet = true }) {
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
        } else {
            viewModel.fetchSearchData(
                destinationId: destinationId,
                destinationType: destinationType,
                location: location,
                checkInDate: checkInDate,
                checkOutDate: checkOutDate,
                currency: currency,
                productCodes: productCodes
            )
        }
    }
}
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

