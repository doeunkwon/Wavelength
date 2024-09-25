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
            let codableBreakdown = try decoder.decode(CodableBreakdown.self, from: data)
            
            let breakdown = Breakdown(bid: codableBreakdown.bid ?? "", goal: codableBreakdown.goal ?? 0, value: codableBreakdown.value ?? 0, interest: codableBreakdown.interest ?? 0, memory: codableBreakdown.memory ?? 0)
            
            return breakdown
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func createBreakdown(newData: CodableBreakdown, fid: String, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/breakdown/\(fid)") else {
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
            let decodedBID = try decoder.decode(DecodedBID.self, from: data)
            return decodedBID.bid
        } catch {
            throw ServiceError.onlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func updateBreakdown(fid: String, newData: CodableBreakdown, bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/breakdown/\(fid)") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
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
            throw ServiceError.onlineError(Strings.Errors.invalidResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.onlineError(Strings.Errors.serverError)
        }
    }
}
