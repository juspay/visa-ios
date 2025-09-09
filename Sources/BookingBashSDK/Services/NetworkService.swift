//
//  NetworkService.swift
//  VisaActivity
//
//  Created by Apple on 29/07/25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - GET Request
    func get<T: Codable>(url: URL, headers: [String: String]? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        
        // Add headers if provided
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNilError", code: -1001, userInfo: nil)))
                return
            }
            do {
                print("Raw Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("Decoded Data: \(decodedData)")
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - POST Request
    func post<T: Codable, U: Codable>(url: URL, body: T, headers: [String: String]? = nil, completion: @escaping (Result<U, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add headers if provided
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataNilError", code: -1001, userInfo: nil)))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
