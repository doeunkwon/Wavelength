//
//  LLMService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI
import Foundation

class LLMService {
    
    static let shared = LLMService()
    
    private init() {}
    
    func generateLLMScore(fid: String, bearerToken: String) async throws -> LLMScore {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/llm/score/\(fid)") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
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
            let decodedLLMScore = try decoder.decode(DecodedLLMScore.self, from: data)
            let llmScore = LLMScore(goal: decodedLLMScore.goal, value: decodedLLMScore.value, interest: decodedLLMScore.interest, memory: decodedLLMScore.memory, analysis: decodedLLMScore.analysis)
            return llmScore
        } catch {
            throw ServiceError.onlineError(Strings.Errors.decodeFailed)
        }
    }
}
