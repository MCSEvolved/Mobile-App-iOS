//
//  DAO.swift
//  MCSynergy
//
//  Created by Josian van Efferen on 03/07/2023.
//

import Foundation

class DAO {
    let baseUrl: String = "https://api.mcsynergy.nl"
    
    func Request(method: String, url: String, token: String, body: Data? = nil) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            guard let requestUrl = URL(string: "\(baseUrl)\(url)") else {
                continuation.resume(throwing: ApiError.urlIsNil)
                return
            }
            var request: URLRequest = URLRequest(url: requestUrl)
            request.httpMethod = method
            request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
            if (method == "POST") {
                request.httpBody = body
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error!.localizedDescription)")
                    continuation.resume(throwing: error!)
                    return
                }
                let response = response as! HTTPURLResponse
                guard response.statusCode < 300 else {
                    switch response.statusCode {
                    case 400:
                        continuation.resume(throwing: ApiError.badRequest)
                        return
                    case 401:
                        continuation.resume(throwing: ApiError.unauthorized)
                        return
                    case 403:
                        continuation.resume(throwing: ApiError.forbidden)
                        return
                    case 404:
                        continuation.resume(throwing: ApiError.notFound)
                        return
                    default:
                        continuation.resume(throwing: ApiError.serverError)
                        return
                    }
                }
                
                continuation.resume(returning: data)
                return
            }
            
            task.resume()
        }
    }
}
