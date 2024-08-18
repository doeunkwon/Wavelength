//
//  UserService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import Foundation
import SwiftUI

enum UserServiceError: Error {
    case unauthorized
    case networkError(Error)
    case unknownError(String)
}

class UserService {
    
    func fetchUser() async throws -> User {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/users") else {
            throw UserServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw UserServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedUser = try decoder.decode(DecodedUser.self, from: data)
            let user = User(
                uid: decodedUser.uid,
                emoji: decodedUser.emoji,
                color: Color(hex: decodedUser.color) ?? .wavelengthOffWhite, // Assuming conversion from string
                firstName: decodedUser.firstName,
                lastName: decodedUser.lastName,
                username: decodedUser.username,
                email: decodedUser.email,
                password: decodedUser.password,
                goals: decodedUser.goals,
                interests: decodedUser.interests,
                scorePercentage: 50, // !!!
                tokenCount: decodedUser.tokenCount,
                memoryCount: decodedUser.memoryCount,
                values: decodedUser.values
            )
            return user
        } catch {
            throw UserServiceError.unknownError("Error decoding user data")
        }
    }
    
    // Helper function to retrieve access token (replace with your implementation)
    private func getToken() -> String {
        // Replace this with your actual token retrieval logic
        // For example, using UserDefaults or Keychain
        // Won't be able to implement until I implement login screen !!!
        return ServiceUtils.testToken
    }
}
