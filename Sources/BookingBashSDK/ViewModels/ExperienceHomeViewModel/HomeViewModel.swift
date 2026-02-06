import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var experiences: [Experience] = []
    @Published var isLoading: Bool = true
    @Published var errorMessage: String = ""
    @Published var ssoLoginResponse: SSOLoginResponseModel?
    @Published var isSSOLoginLoading = false
    @Published var homeResponseData: HomeResponseModel?
    @Published var destinations: [Destination] = []
    @Published var currencyListData: CurrencyListDataModel? = nil
    @Published var allExperiences: [Experience] = []
    @Published var showMenu = false

    private let loadCount = 700
    private let service: HomeService
    private var cancellables = Set<AnyCancellable>()
    
    init(service: HomeService = DefaultHomeService()) {
        self.service = service
    }

    func fetchHomeData() {
        isLoading = true
        errorMessage = ""
        
        service.fetchHome { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.homeResponseData = response
                    self.processHomeResponse(response)
                case .failure(let error):
                    self.setError(error.localizedDescription)
                }
            }
        }
    }

    func performSSOLogin(encryptedToken: String) {
        isSSOLoginLoading = true
        errorMessage = ""
        
        service.ssoLogin(encryptedToken: encryptedToken) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSSOLoginLoading = false
                
                switch result {
                case .success(let response):
                    self.ssoLoginResponse = response
                    self.processSSOLoginResponse(response)
                    if response.status == false {
                        self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                    }
                    
                case .failure(_):
                    self.errorMessage = Constants.ErrorMessages.somethingWentWrong
                }
            }
        }
    }
    
    func performInitialLoad(
        encryptedToken: String,
        onError: @escaping (String) -> Void
    ) {
        performSSOLogin(encryptedToken: encryptedToken)
        $ssoLoginResponse
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                if response.status == true {
                    self.getCurrencyListData {
                        self.fetchHomeData()
                    }
                } else {
                    onError(Constants.ErrorMessages.authFail)
                }
            }
            .store(in: &cancellables)
        
        $errorMessage
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { error in
                guard !error.isEmpty else { return }
                onError(Constants.ErrorMessages.authFail)
            }
            .store(in: &cancellables)
    }
    
    private func processHomeResponse(_ response: HomeResponseModel) {
        let exploreDestinationNew = response.data?.body?.mobile?
            .first(where: { $0.bannerData == "VAC-ExploreDestinationNew" })?
            .data

        destinations = exploreDestinationNew?.map { apiDestination in
            return Destination(name: apiDestination.name ?? "",
                               imageURL: ((ssoLoginResponse?.data.siteUrl ?? Constants.APIURLs.baseURL) + "/shared/api/media/" + (apiDestination.mobileBanner ?? "")),
                               destinationId: apiDestination.destinationID ?? "",
                               destinationType: apiDestination.destinationType ?? 0)
        } ?? []

        let epicExpCompNewDynamic = response.data?.body?.mobile?
            .first(where: { $0.bannerData == "VAC-Epic Experience" })?
            .data
        
        allExperiences = epicExpCompNewDynamic?.map { activity in
            let priceModel: HomePriceModel? = {
                    if case .price(let model) = activity.price {
                        return model
                    }
                    return nil
                }()
            return Experience(imageURL: activity.thumbnail ?? "",
                              title: activity.title ?? "",
                              originalPrice:  priceModel?.strikeout?.totalAmount ?? priceModel?.totalAmount ?? 0.00,
                              discount: priceModel?.strikeout?.savingPercentage ?? 0.00,
                              finalPrice: priceModel?.totalAmount ?? 0.00,
                              productCode: activity.activityCode ?? "",
                              currency: priceModel?.currency ?? currencyGlobal,
                              pricingModel: priceModel?.pricingModel ?? "")
        } ?? []
        let termsAndConditionsEndPoint = response.data?.footer?.menu.first(where: { $0.text ==  "Terms & Conditions" })?.url ?? ""
        if let siteUrl = ssoLoginResponse?.data.siteUrl {
            termsAndConditionsUrlGlobal = siteUrl + termsAndConditionsEndPoint
            let privacyPolicyEndPoint = response.data?.footer?.menu.first(where: { $0.text ==  "Privacy Policy" })?.url ?? ""
            privacyPolicyUrlGlobal = siteUrl + privacyPolicyEndPoint
        }
        experiences = allExperiences
    }

    private func setError(_ message: String) {
        errorMessage = message
    }
    
    private func processSSOLoginResponse(_ response: SSOLoginResponseModel) {
        ssoTokenGlobal = response.data.accessToken
        ssoSiteIdGlobal = response.data.siteId
        firstName = response.data.loyalty.req.memberProfile.firstName
        lastName = response.data.loyalty.req.memberProfile.lastName
        mobileNumber = response.data.mobileNumber
        customerEmail = response.data.email
        mobileCountryCode = response.data.countryCode
    }
}

extension HomeViewModel {
    func getCurrencyListData(completion: @escaping () -> Void) {
        service.getCurrencyListData { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {

                    self.currencyListData = response?.currencyListData

                    // 1️⃣ Check UserDefaults first
                    if let savedCurrency: String = UserDefaultsManager.shared.get(for: UserDefaultsKey.activeCurrency.rawValue) {
                        currencyGlobal = savedCurrency
                        completion()
                        return
                    }

                    // 2️⃣ Fallback to API mapping
                    if let otherCurrencies = response?.currencyListData?.other,
                       let popularCurrencies = response?.currencyListData?.popular {

                        let allCurrencies = otherCurrencies + popularCurrencies

                        let apiActiveCurrency =
                            allCurrencies.first {
                                $0.status?.lowercased() == "active"
                            }?.code ?? currencyGlobal

                        currencyGlobal = apiActiveCurrency

                        // 3️⃣ Store for next launch
                        UserDefaultsManager.shared.set(apiActiveCurrency, for: UserDefaultsKey.activeCurrency.rawValue)
                    }

                    completion()
                }

            case .failure(_):
                DispatchQueue.main.async {

                    // 4️⃣ Final fallback
                    let fallbackCurrency = currencyGlobal
                    currencyGlobal = fallbackCurrency

                    completion()
                }
            }
        }
    }
}
