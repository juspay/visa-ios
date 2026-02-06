import Foundation
import CommonCrypto

final class NetworkManager: NSObject {

    static let shared = NetworkManager()

    private lazy var sslSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: SSLPublicKeyPinningDelegate(), delegateQueue: nil)
    }()

    private override init() { super.init() }

    // MARK: - GET Request
    func get<T: Codable>(
        url: URL,
        params: [String: String]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        if let params = params {
            components?.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }

        guard let finalURL = components?.url else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"

        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

//        print("=========== Request:\n\(request.curlString)\n===========")

        sslSession.dataTask(with: request) { data, _, error in
            self.handleResponse(data: data, error: error, completion: completion)
        }.resume()
    }

    // MARK: - POST Request
    func post<T: Codable, U: Codable>(
        url: URL,
        body: T,
        headers: [String: String]? = nil,
        completion: @escaping (Result<U, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            return completion(.failure(error))
        }
//        print("=========== Request: \t \(request.curlString)\n ===========")
        sslSession.dataTask(with: request) { data, _, error in
            self.handleResponse(data: data, error: error, completion: completion)
        }.resume()
    }

    // MARK: - Response Handling
    private func handleResponse<T: Codable>(
        data: Data?,
        error: Error?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "DataNilError", code: -1001)))
            return
        }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

            if let prettyString = String(data: prettyData, encoding: .utf8) {
//                print("JSON Decoded. Pretty JSON:")
//                print(prettyString)
            }
            let decoded = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decoded))
        } catch {
//            do {
//                   let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
//                   let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
//
//                   if let prettyString = String(data: prettyData, encoding: .utf8) {
//                       print("❌ JSON Decoding Failed. Pretty JSON:")
//                       print(prettyString)
//                   }
//               } catch {
//                   print("❌ Failed to parse JSON for debugging")
//               }
                completion(.failure(error))
        }
    }
}
