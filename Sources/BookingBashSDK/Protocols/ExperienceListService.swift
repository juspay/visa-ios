
import Foundation

protocol ExperienceListService {
    func fetchSearchData(
        requestBody: SearchRequestModel,
        completion: @escaping (Result<SearchResponseModel, Error>) -> Void
    )
}

final class DefaultExperienceListService: ExperienceListService {
    private let session = NetworkManager.shared
    func fetchSearchData(
        requestBody: SearchRequestModel,
        completion: @escaping (Result<SearchResponseModel, Error>) -> Void
    ) {
        guard let url = URL(string: Constants.APIURLs.searchBaseURL) else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        let headers = [
            Constants.APIHeaders.contentTypeKey: Constants.APIHeaders.contentTypeValue,
            Constants.APIHeaders.authorizationKey: TokenProvider.getAuthHeader() ?? "",
            Constants.APIHeaders.siteId: ssoSiteIdGlobal,
            Constants.APIHeaders.tokenKey: ssoTokenGlobal
        ]
        session.post(url: url, body: requestBody, headers: headers, completion: completion)
    }
    enum ServiceError: LocalizedError {
        case invalidURL
        var errorDescription: String? { "Invalid URL" }
    }
}

