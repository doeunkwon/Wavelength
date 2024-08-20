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
    
    func getFriends() async throws -> [Friend] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends") else {
            throw FriendServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedFriends = try decoder.decode([DecodedFriend].self, from: data)
            
            let friends: [Friend] = decodedFriends.map { decodedFriend in
                Friend(
                    fid: decodedFriend.fid,
                    scorePercentage: decodedFriend.scorePercentage,
                    scoreAnalysis: decodedFriend.scoreAnalysis,
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
    
    func updateFriend(fid: String, newData: EncodedFriend) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends/\(fid)") else {
            throw FriendServiceError.unknownError("Failed to create URL")
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
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        // Handle success response (optional) - You might not need to decode anything on success
        print("Friend updated successfully!")
    }
    
    // Helper function to retrieve access token (replace with your implementation)
    private func getToken() -> String {
        // Replace this with your actual token retrieval logic
        // For example, using UserDefaults or Keychain
        // Won't be able to implement until I implement login screen !!!
        return ServiceUtils.testToken
    }
}
