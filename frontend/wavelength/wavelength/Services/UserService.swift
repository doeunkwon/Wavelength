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
    
    @EnvironmentObject var viewModel: ViewModel
    
    func getUser() async throws -> User {
        
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
                scorePercentage: decodedUser.scorePercentage,
                tokenCount: decodedUser.tokenCount,
                memoryCount: decodedUser.memoryCount,
                values: decodedUser.values
            )
            return user
        } catch {
            throw UserServiceError.unknownError("Error decoding user data")
        }
    }
    
    func updateUser(newData: EncodedUser) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/users") else {
            throw UserServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert user object to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(newData)

        urlRequest.httpBody = jsonData

        let (_, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw UserServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        // Handle success response (optional) - You might not need to decode anything on success
        print("User updated successfully!")
    }
    
    // Helper function to retrieve access token (replace with your implementation)
    private func getToken() -> String {
        // Replace this with your actual token retrieval logic
        // For example, using UserDefaults or Keychain
        // Won't be able to implement until I implement login screen !!!
        return viewModel.bearerToken
    }
}
