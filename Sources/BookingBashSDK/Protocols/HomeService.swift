import Foundation
import Combine

protocol HomeService {
    func ssoLogin(encryptedToken: String, completion: @escaping (Result<SSOLoginResponseModel, Error>) -> Void)
    func fetchHome(completion: @escaping (Result<HomeResponseModel, Error>) -> Void)
    func getCurrencyListData(completion: @escaping (Result<CurrencyListResponseModel?, Error>) -> Void)
}

final class DefaultHomeService: HomeService {
    private let session = NetworkManager.shared
    
    func fetchHome(completion: @escaping (Result<HomeResponseModel, Error>) -> Void) {
        guard let url = URL(string: Constants.APIURLs.newhomeBaseURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        let params = [ "currency": currencyGlobal ]
 
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.accessToken: ssoTokenGlobal,
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? ""
        ]
        
        session.get(url: url, params: params, headers: headers, completion: completion)
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

    func getCurrencyListData(completion: @escaping (Result<CurrencyListResponseModel?, Error>) -> Void) {
        guard let url = URL(string: Constants.APIURLs.currencyListURL) else {
            return
        }
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        session.get(url: url, headers: headers, completion: completion)
    }
}
