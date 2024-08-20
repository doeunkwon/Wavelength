//
//  ScoreService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import Foundation
import SwiftUI

enum ScoreServiceError: Error {
    case unauthorized
    case networkError(Error)
    case unknownError(String)
}

class ScoreService {
    
    func getScores() async throws -> [Score] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/scores") else {
            throw ScoreServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")

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
    
    // Helper function to retrieve access token (replace with your implementation)
    private func getToken() -> String {
        // Replace this with your actual token retrieval logic
        // For example, using UserDefaults or Keychain
        // Won't be able to implement until I implement login screen !!!
        return ServiceUtils.testToken
    }
}
