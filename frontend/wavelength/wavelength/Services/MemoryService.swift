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
    
    func fetchMemories(fid: String) async throws -> [Memory] {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/memories/\(fid)") else {
            throw UserServiceError.unknownError("Failed to create URL")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw UserServiceError.networkError(NSError(domain: "HTTP", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw UserServiceError.networkError(NSError(domain: "HTTP", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
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
    
    // Helper function to retrieve access token (replace with your implementation)
    private func getToken() -> String {
        // Replace this with your actual token retrieval logic
        // For example, using UserDefaults or Keychain
        // Won't be able to implement until I implement login screen !!!
        return ServiceUtils.testToken
    }
}
