//
//  FriendService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import Foundation
import SwiftUI

class FriendService {
    
    func getFriends(bearerToken: String) async throws -> [Friend] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends") else {
            throw FriendServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let codableFriend = try decoder.decode([CodableFriend].self, from: data)
            
            let friends: [Friend] = codableFriend.map { codableFriend in
                Friend(
                    fid: codableFriend.fid ?? "",
                    scorePercentage: codableFriend.scorePercentage ?? 0,
                    scoreAnalysis: codableFriend.scoreAnalysis ?? "",
                    tokenCount: codableFriend.tokenCount ?? 0,
                    memoryCount: codableFriend.memoryCount ?? 0,
                    emoji: codableFriend.emoji ?? "",
                    color: Color(hex: codableFriend.color ?? "000000") ?? .wavelengthOffWhite,
                    firstName: codableFriend.firstName ?? "",
                    lastName: codableFriend.lastName ?? "",
                    goals: codableFriend.goals ?? "",
                    interests: codableFriend.interests ?? [],
                    values: codableFriend.values ?? [])
            }
            
            return friends
        } catch {
            throw FriendServiceError.unknownError("Error decoding friend data")
        }
    }
    
    func updateFriend(fid: String, newData: CodableFriend, bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends/\(fid)") else {
            throw FriendServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
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

        print("Friend updated successfully!")
    }
    
    func createFriend(newData: CodableFriend, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends") else {
            throw FriendServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert user object to JSON data
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(newData)

        urlRequest.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw FriendServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedFID = try decoder.decode(DecodedFID.self, from: data)
            return decodedFID.fid
        } catch {
            throw FriendServiceError.networkError(NSError(domain: "JSON", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
        }
    }
    
    func deleteFriend(fid: String, bearerToken: String) async throws {
      guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/friends/\(fid)") else {
        throw FriendServiceError.unknownError("Failed to create URL")
      }

      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = "DELETE"
      urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

      let (_, response) = try await URLSession.shared.data(for: urlRequest)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw FriendServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
      }

      guard (200...299).contains(httpResponse.statusCode) else {
          throw FriendServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
      }
      
      // Friend deleted successfully (no data to decode on success for DELETE)
      print("Friend deleted successfully!")
    }
}
