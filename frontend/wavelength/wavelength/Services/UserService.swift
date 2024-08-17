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
        
        print("les go")

        do {
            print("CHECKPOINT 1")
            let decoder = JSONDecoder()
            print("CHECKPOINT 2")
            let decodedUser = try decoder.decode(DecodedUser.self, from: data)
            print("CHECKPOINT 3")
            let user = User(
                uid: decodedUser.uid,
                emoji: decodedUser.emoji,
                color: Color(hex: decodedUser.color), // Assuming conversion from string
                firstName: decodedUser.firstName,
                lastName: decodedUser.lastName,
                username: decodedUser.username,
                email: decodedUser.email,
                password: decodedUser.password,
                goals: decodedUser.goals,
                interests: decodedUser.interests,
                scorePercentage: decodedUser.scorePercentage,
                tokenCount: decodedUser.tokenCount,
                memoryCount: decodedUser.memoryCount,
                values: decodedUser.values
            )
            print("CHECKPOINT 4")
            return user
        } catch {
            throw UserServiceError.unknownError("Error decoding user data")
        }
    }
    
    // Helper function to retrieve access token (replace with your implementation)
    private func getToken() -> String {
        // Replace this with your actual token retrieval logic
        // For example, using UserDefaults or Keychain
        return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmYjdmMjBhYy1mNzQxLTRmY2YtYWNhMy01ZTAwNzk2MzY5YzUiLCJleHAiOjE3MjM4ODc5NzcuNTgwOTR9.gA9jMl9b49vxoG2eFKYLX8_Q6pr8Bdc6mb2F4iTQHjo"
    }
}
