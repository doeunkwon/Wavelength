//
//  MemoryService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import Foundation
import SwiftUI

enum MemoryServiceError: Error {
    case unauthorized
    case networkError(Error)
    case unknownError(String)
}

class MemoryService {
    
    @EnvironmentObject var viewModel: ViewModel
    
    func getMemories(fid: String, bearerToken: String) async throws -> [Memory] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(fid)") else {
            throw MemoryServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedMemories = try decoder.decode([DecodedMemory].self, from: data)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm E, d MMM y"
            
            let memories: [Memory] = decodedMemories.map { decodedMemory in
                Memory(
                    mid: decodedMemory.mid,
                    date: dateFormatter.date(from: decodedMemory.date) ?? Date(),
                    title: decodedMemory.title,
                    content: decodedMemory.content,
                    tokens: decodedMemory.tokens)
            }
            
            return memories
        } catch {
            throw MemoryServiceError.unknownError("Error decoding memory data")
        }
    }
    
    func updateMemory(mid: String, newData: EncodedMemory, bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(mid)") else {
            throw MemoryServiceError.unknownError("Failed to create URL")
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
            throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }
    }
    
    func createMemory(newData: EncodedMemory, fid: String, bearerToken: String) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(fid)") else {
            throw MemoryServiceError.unknownError("Failed to create URL")
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
            throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }

        do {
            let decoder = JSONDecoder()
            let decodedMID = try decoder.decode(DecodedMID.self, from: data)
            return decodedMID.mid
        } catch {
            throw MemoryServiceError.networkError(NSError(domain: "JSON", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JSON"]))
        }
    }
    
    func deleteMemory(mid: String, bearerToken: String) async throws {
      guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(mid)") else {
        throw MemoryServiceError.unknownError("Failed to create URL")
      }

      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = "DELETE"
      urlRequest.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

      let (_, response) = try await URLSession.shared.data(for: urlRequest)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
      }

      guard (200...299).contains(httpResponse.statusCode) else {
        if httpResponse.statusCode == 401 {
          throw MemoryServiceError.unauthorized
        } else {
          throw MemoryServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }
      }
      
      // Memory deleted successfully (no data to decode on success for DELETE)
      print("Memory deleted successfully!")
    }
}
