//
//  AuthenticationService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-23.
//

import SwiftUI

class AuthenticationService {
    
    func signIn(username: String, password: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/login") else {
          throw AuthenticationServiceError.unknownError("Failed to create URL")
        }
          
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")


        // Build the form data dictionary
        let formData = ["username": username, "password": password]

        // Encode the form data as a string
        let postData = formData.map { key, value in
            return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        }.joined(separator: "&")

        // Set the encoded data as the request body
        urlRequest.httpBody = postData.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthenticationServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthenticationServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedResponse = try decoder.decode(DecodedAuthentication.self, from: data)
            return decodedResponse.access_token
        } catch {
            throw AuthenticationServiceError.networkError(NSError(domain: "JSON", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
        }
    }
    
}
