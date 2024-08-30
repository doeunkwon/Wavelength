//
//  BreakdownService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI
import Foundation

class BreakdownService {
    
    func getBreakdown(fid: String, bearerToken: String) async throws -> Breakdown {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/breakdown/\(fid)") else {
            throw BreakdownServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw BreakdownServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw BreakdownServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }
        

        do {
            let decoder = JSONDecoder()
            let decodedBreakdown = try decoder.decode(DecodedBreakdown.self, from: data)
            
            let breakdown = Breakdown(bid: decodedBreakdown.bid, goal: decodedBreakdown.goal, value: decodedBreakdown.value, interest: decodedBreakdown.interest, memory: decodedBreakdown.memory)
            
            return breakdown
        } catch {
            throw BreakdownServiceError.unknownError("Error decoding score data")
        }
    }
    
    func createBreakdown(newData: EncodedBreakdown, fid: String, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/breakdown/\(fid)") else {
            throw BreakdownServiceError.unknownError("Failed to create URL")
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
            throw BreakdownServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw BreakdownServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedBID = try decoder.decode(DecodedBID.self, from: data)
            return decodedBID.bid
        } catch {
            throw BreakdownServiceError.networkError(NSError(domain: "JSON", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
        }
    }
}
