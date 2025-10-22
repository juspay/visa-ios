import Foundation
import Combine

protocol HomeService {
    func fetchHome(completion: @escaping (Result<HomeResponseModel, Error>) -> Void)
    func decrypt(jwe: String, completion: @escaping (Result<DecryptedResponse, Error>) -> Void)
    func ssoLogin(encryptedToken: String, completion: @escaping (Result<SSOLoginResponseModel, Error>) -> Void)
}

final class DefaultHomeService: HomeService {
    private let session = NetworkManager.shared
    
    func fetchHome(completion: @escaping (Result<HomeResponseModel, Error>) -> Void) {
        guard let url = URL(string: Constants.APIURLs.homeBaseURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: Constants.SharedConstants.siteId
        ]
        
        session.get(url: url, headers: headers, completion: completion)
    }
    
    func decrypt(jwe: String, completion: @escaping (Result<DecryptedResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.APIURLs.decryptURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let body = ["jwe": jwe]
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
        ]
        session.post(url: url, body: body, headers: headers, completion: completion)
    }
    
    func ssoLogin(encryptedToken: String, completion: @escaping (Result<SSOLoginResponseModel, Error>) -> Void) {
        guard let url = URL(string: Constants.APIURLs.ssoLoginURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let body = ["token": encryptedToken]
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.siteKey: Constants.SharedConstants.sso_siteKey,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? ""
        ]
        session.post(url: url, body: body, headers: headers, completion: completion)
    }
    
    enum ServiceError: LocalizedError {
        case invalidURL
        var errorDescription: String? { "Invalid URL" }
    }
}

final class HomeViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var experiences: [Experience] = []
    @Published var homeResponseData: HomeResponseModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var decryptedResponse: DecryptedResponse?
    @Published var isDecryptionLoading = false
    @Published var ssoLoginResponse: SSOLoginResponseModel?
    @Published var isSSOLoginLoading = false
    
    private var allExperiences: [Experience] = []
    private let loadCount = 5
    private let service: HomeService
    
    init(service: HomeService = DefaultHomeService()) {
        self.service = service
    }
    
    func loadHome(encryptPayload: String) {
//        decryptPayload(encryptPayload)
        fetchHomeData()
        performSSOLogin(encryptedToken: encryptPayload)
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
    
    func decryptPayload(_ jwe: String) {
        isDecryptionLoading = true
        service.decrypt(jwe: jwe) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isDecryptionLoading = false
                switch result {
                case .success(let decoded):
                    self.decryptedResponse = decoded
                    self.assignGlobalValues(from: decoded)
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
                case .failure(let error):
                    self.setError(error.localizedDescription)
                }
            }
        }
    }
    
    private func processHomeResponse(_ response: HomeResponseModel) {
        
        // Process destinations with detailed logging
        destinations = response.data.popularDestinations.enumerated().map { index, apiDestination in
            return Destination(
                name: apiDestination.title,
                imageURL: apiDestination.image,
                destinationId: apiDestination.destinationId,
                destinationType: apiDestination.destinationType,
                locationName: apiDestination.locationName,
                city: apiDestination.city,
                state: apiDestination.state,
                region: apiDestination.region
            )
        }
        
        // Process activities with detailed logging
        allExperiences = response.data.featuredActivities.enumerated().map { index, activity in
        
            // Use activityCode if available, otherwise fallback to productId or destinationId
            let productCode = activity.activityCode ?? activity.productId ?? activity.destinationId
            
            return Experience(
                imageURL: activity.thumbnail,
                country: activity.destinationName,
                title: activity.title,
                originalPrice: Int(activity.price.strikeout?.totalAmount ?? activity.price.totalAmount),
                discount: activity.price.strikeout?.savingPercentage ?? 0,
                finalPrice: Int(activity.price.totalAmount),
                productCode: productCode
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
    
    private func assignGlobalValues(from response: DecryptedResponse) {
        firstName = response.payload.firstName
        lastName = response.payload.lastName
        mobileNumber = response.payload.mobileNumber
        mobileCountryCode = response.payload.mobileCountryCode
        customerEmail = response.payload.customerEmail
        aliasId = response.payload.aliasId
        customerId = response.payload.customerId
        isDeeplink = response.payload.isDeeplink
        location = response.payload.location
    }
        
    private func setError(_ message: String) {
        errorMessage = message
        print("HomeViewModel Error:", message)
    }
    
    private func processSSOLoginResponse(_ response: SSOLoginResponseModel) {
        // Print the complete response for debugging
        print("=== SSO Login Response ===")
        print("Status: \(response.status)")
        print("Message: \(response.message)")
        print("Login Type: \(response.data.loginType)")
        print("User ID: \(response.data.userId)")
        print("First Name: \(response.data.firstName)")
        print("Last Name: \(response.data.lastName)")
        print("Email: \(response.data.email)")
        print("Access Token: \(response.data.accessToken)")
        print("Refresh Token: \(response.data.refreshToken)")
        print("Site URL: \(response.data.siteUrl)")
        print("Site ID: \(response.data.siteId)")
        print("Org ID: \(response.data.orgId)")
        print("Profile Image: \(response.data.profileImage)")
        print("Type: \(response.data.type)")
        print("Open Booking: \(response.data.openBooking)")
        print("Show Wallet: \(response.data.showWallet)")
        print("Site Decimal Place: \(response.data.siteDecimalPlace)")
        print("Login Flow: \(response.data.loginFlow)")
        print("Loyalty Status: \(response.data.loyalty.status)")
        print("Loyalty Points Balance: \(response.data.loyalty.pointsBalance)")
        print("Member ID: \(response.data.loyalty.req.memberProfile.memberId)")
        print("========================")
        ssoTokenGlobal = response.data.accessToken
        ssoSiteIdGlobal = response.data.siteId
        firstName = response.data.loyalty.req.memberProfile.firstName
        lastName = response.data.loyalty.req.memberProfile.lastName
        mobileNumber = response.data.mobileNumber
        customerEmail = response.data.email
        mobileCountryCode = response.data.countryCode
        
        
    
        // You can store tokens or other important data here
        // For example, save access token for future API calls
        // TokenProvider.saveAccessToken(response.data.accessToken)
    }
}
