import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var experiences: [Experience] = []
    @Published var homeResponseData: HomeResponseModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var ssoLoginResponse: SSOLoginResponseModel?
    @Published var isSSOLoginLoading = false
    
    private var allExperiences: [Experience] = []
    private let loadCount = 5
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
                    
                case .failure(let error):
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
                    self.fetchHomeData()
                } else {
                    onError(Constants.ErrorMessages.somethingWentWrong)
                }
            }
            .store(in: &cancellables)
        
        $errorMessage
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { error in
                guard !error.isEmpty else { return }
                onError(Constants.ErrorMessages.somethingWentWrong)
            }
            .store(in: &cancellables)
    }
    
    private func processHomeResponse(_ response: HomeResponseModel) {
        
        destinations = response.data.popularDestinations.enumerated().map { index, apiDestination in
            return Destination(
                name: apiDestination.title,
                imageURL: apiDestination.image,
                destinationId: apiDestination.destinationId,
                destinationType: apiDestination.destinationType,
                locationName: apiDestination.locationName,
                city: apiDestination.city,
                state: apiDestination.state,
                region: apiDestination.region,
                currency: response.data.currency
            )
        }
        
        allExperiences = response.data.featuredActivities.enumerated().map { index, activity in
            
            let productCode = activity.activityCode ?? activity.productId ?? activity.destinationId
            
            return Experience(
                imageURL: activity.thumbnail,
                country: activity.destinationName,
                title: activity.title,
                originalPrice: Int(activity.price.strikeout?.totalAmount ?? activity.price.totalAmount),
                discount: activity.price.strikeout?.savingPercentage ?? 0,
                finalPrice: Int(activity.price.totalAmount),
                productCode: productCode, currency: activity.price.currency
            )
        }
        termsAndConditionsUrlGlobal = response.data.pageUrls.termsAndConditions
        privacyPolicyUrlGlobal = response.data.pageUrls.privacyPolicy
        loadMoreExperiences()
    }
    
    func loadMoreExperiences() {
        let remaining = allExperiences.dropFirst(experiences.count)
        let nextChunk = remaining.prefix(loadCount)
        experiences.append(contentsOf: nextChunk)
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
