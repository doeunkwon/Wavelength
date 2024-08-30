//
//  ScoreService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import Foundation
import SwiftUI

class ScoreService {
    
    func getUserScores(bearerToken: String) async throws -> [Score] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores") else {
            throw ScoreServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }
        

        do {
            let decoder = JSONDecoder()
            let decodedScores = try decoder.decode([DecodedScore].self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let scores: [Score] = decodedScores.map { decodedScore in
                Score(
                    sid: decodedScore.sid,
                    timestamp: dateFormatter.date(from: decodedScore.timestamp) ?? Date(),
                    percentage: decodedScore.percentage,
                    analysis: decodedScore.analysis
                )
            }
            
            return scores
        } catch {
            throw ScoreServiceError.unknownError("Error decoding score data")
        }
    }
    
    func getFriendScores(fid: String, bearerToken: String) async throws -> [Score] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores/\(fid)") else {
            throw ScoreServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }
        

        do {
            let decoder = JSONDecoder()
            let decodedScores = try decoder.decode([DecodedScore].self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let scores: [Score] = decodedScores.map { decodedScore in
                Score(
                    sid: decodedScore.sid,
                    timestamp: dateFormatter.date(from: decodedScore.timestamp) ?? Date(),
                    percentage: decodedScore.percentage,
                    analysis: decodedScore.analysis
                )
            }
            
            return scores
        } catch {
            throw ScoreServiceError.unknownError("Error decoding score data")
        }
    }
    
    func createUserScore(newData: EncodedScore, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores") else {
            throw ScoreServiceError.unknownError("Failed to create URL")
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
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedSID = try decoder.decode(DecodedSID.self, from: data)
            return decodedSID.sid
        } catch {
            throw ScoreServiceError.networkError(NSError(domain: "JSON", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
        }
    }
    
    func createFriendScore(newData: EncodedScore, fid: String, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores/\(fid)") else {
            throw ScoreServiceError.unknownError("Failed to create URL")
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
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ScoreServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedSID = try decoder.decode(DecodedSID.self, from: data)
            return decodedSID.sid
        } catch {
            throw ScoreServiceError.networkError(NSError(domain: "JSON", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
        }
    }
    
}
