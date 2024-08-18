//
//  FriendService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import Foundation
import SwiftUI

enum FriendServiceError: Error {
    case unauthorized
    case networkError(Error)
    case unknownError(String)
}

class FriendService {
    
    func fetchFriends() async throws -> [Friend] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends") else {
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
            let decodedFriends = try decoder.decode([DecodedFriend].self, from: data)
            
            let friends: [Friend] = decodedFriends.map { decodedFriend in
                Friend(
                    fid: decodedFriend.fid,
                    scorePercentage: 50,
                    scoreAnalysis: "WOW!",
                    tokenCount: decodedFriend.tokenCount,
                    memoryCount: decodedFriend.memoryCount,
                    emoji: decodedFriend.emoji,
                    color: Color(hex: decodedFriend.color) ?? .wavelengthOffWhite,
                    firstName: decodedFriend.firstName,
                    lastName: decodedFriend.lastName,
                    goals: decodedFriend.goals,
                    interests: decodedFriend.interests,
                    values: decodedFriend.values)
            }
            
            return friends
        } catch {
            throw FriendServiceError.unknownError("Error decoding friend data")
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
