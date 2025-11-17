import Foundation
import Combine

protocol HomeService {
    func fetchHome(completion: @escaping (Result<HomeResponseModel, Error>) -> Void)
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
    
    func ssoLogin(encryptedToken: String, completion: @escaping (Result<SSOLoginResponseModel, Error>) -> Void) {
        guard let url = URL(string: Constants.APIURLs.ssoLoginURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let body = [Constants.APIHeaders.tokenKey: encryptedToken]
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
