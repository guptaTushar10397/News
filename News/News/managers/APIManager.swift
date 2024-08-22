//
//  APIManager.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    
    private init() { }
}

enum APIErrors: Error {
    case InvalidResponseCode
}

extension APIManager {
    
    func getData<T: Codable>(fromUrl url: URL) async throws -> T {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse,
              (200 ... 299).contains(response.statusCode) else {
            throw APIErrors.InvalidResponseCode
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
