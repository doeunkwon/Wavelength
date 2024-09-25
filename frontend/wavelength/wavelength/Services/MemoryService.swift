//
//  MemoryService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import Foundation
import SwiftUI

class MemoryService {
    
    func getMemories(fid: String, bearerToken: String) async throws -> [Memory] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(fid)") else {
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
            let codableMemories = try decoder.decode([CodableMemory].self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm E, d MMM y"
            
            let memories: [Memory] = codableMemories.map { codableMemory in
                Memory(
                    mid: codableMemory.mid ?? "",
                    date: dateFormatter.date(from: codableMemory.date ?? "") ?? Date(),
                    title: codableMemory.title ?? "",
                    content: codableMemory.content ?? "",
                    tokens: codableMemory.tokens ?? 0)
            }
            
            return memories
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func updateMemory(mid: String, newData: CodableMemory, bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(mid)") else {
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
    
    func createMemory(newData: CodableMemory, fid: String, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(fid)") else {
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
            let decodedMID = try decoder.decode(DecodedMID.self, from: data)
            return decodedMID.mid
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func deleteMemory(mid: String, bearerToken: String) async throws {
      guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(mid)") else {
        throw ServiceError.offlineError(Strings.Errors.urlFailed)
      }

      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = "DELETE"
      urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

      let (_, response) = try await URLSession.shared.data(for: urlRequest)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw ServiceError.onlineError(Strings.Errors.invalidResponse)
      }

      guard (200...299).contains(httpResponse.statusCode) else {
          throw ServiceError.onlineError(Strings.Errors.serverError)
      }
    }
}
