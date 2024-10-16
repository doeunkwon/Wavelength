//
//  ScoreService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import Foundation
import SwiftUI

class ScoreService {
    
    static let shared = ScoreService()
    
    private init() {}
    
    func getUserScores(bearerToken: String) async throws -> [Score] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.onlineError(Strings.Errors.invalidResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.onlineError(Strings.Errors.serverError)
        }
        

        do {
            let decoder = JSONDecoder()
            let codableScores = try decoder.decode([CodableScore].self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let scores: [Score] = codableScores.map { codableScore in
                Score(
                    sid: codableScore.sid ?? "",
                    timestamp: dateFormatter.date(from: codableScore.timestamp ?? "") ?? Date(),
                    percentage: codableScore.percentage ?? 0,
                    analysis: codableScore.analysis
                )
            }
            
            return scores
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func getFriendScores(fid: String, bearerToken: String) async throws -> [Score] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores/\(fid)") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.onlineError(Strings.Errors.invalidResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.onlineError(Strings.Errors.serverError)
        }
        

        do {
            let decoder = JSONDecoder()
            let codableScores = try decoder.decode([CodableScore].self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let scores: [Score] = codableScores.map { codableScore in
                Score(
                    sid: codableScore.sid ?? "",
                    timestamp: dateFormatter.date(from: codableScore.timestamp ?? "") ?? Date(),
                    percentage: codableScore.percentage ?? 0,
                    analysis: codableScore.analysis
                )
            }
            
            return scores
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func createUserScore(newData: CodableScore, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
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
            throw ServiceError.onlineError(Strings.Errors.invalidResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.onlineError(Strings.Errors.serverError)
        }

        do {
            let decoder = JSONDecoder()
            let decodedSID = try decoder.decode(DecodedSID.self, from: data)
            return decodedSID.sid
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func createFriendScore(newData: CodableScore, fid: String, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores/\(fid)") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
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
            throw ServiceError.onlineError(Strings.Errors.invalidResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.onlineError(Strings.Errors.serverError)
        }

        do {
            let decoder = JSONDecoder()
            let decodedSID = try decoder.decode(DecodedSID.self, from: data)
            return decodedSID.sid
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
}
