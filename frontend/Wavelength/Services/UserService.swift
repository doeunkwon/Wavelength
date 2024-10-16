//
//  UserService.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import Foundation
import SwiftUI

class UserService {
    
    static let shared = UserService()
    
    private init() {}
    
    func getUser(bearerToken: String) async throws -> User {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/users") else {
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
            
            if httpResponse.statusCode == 401 {
                throw ServiceError.unauthorized
            } else {
                throw ServiceError.onlineError(Strings.Errors.serverError)
            }
            
        }

        do {
            let decoder = JSONDecoder()
            let codableUser = try decoder.decode(CodableUser.self, from: data)
            let user = User(
                uid: codableUser.uid ?? "",
                emoji: codableUser.emoji ?? "",
                color: Color(hex: codableUser.color ?? "000000") ?? .wavelengthOffWhite, // Assuming conversion from string
                firstName: codableUser.firstName ?? "",
                lastName: codableUser.lastName ?? "",
                username: codableUser.username ?? "",
                email: codableUser.email ?? "",
                password: codableUser.password ?? "",
                goals: codableUser.goals ?? "",
                interests: codableUser.interests ?? [],
                scorePercentage: codableUser.scorePercentage ?? 0,
                tokenCount: codableUser.tokenCount ?? 0,
                memoryCount: codableUser.memoryCount ?? 0,
                values: codableUser.values ?? []
            )
            return user
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func updateUser(newData: CodableUser, bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/users") else {
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
            if httpResponse.statusCode == 401 {
                throw ServiceError.unauthorized
            } else {
                throw ServiceError.onlineError(Strings.Errors.serverError)
            }
        }
    }
    
    func updatePassword(newData: EncodedPassword, bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/users/password") else {
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
            if httpResponse.statusCode == 401 {
                throw ServiceError.unauthorized
            } else {
                throw ServiceError.onlineError(Strings.Errors.serverError)
            }
        }
    }
    
    func createUser(newData: CodableUser) async throws -> String {
        
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/public/users") else {
            throw ServiceError.offlineError(Strings.Errors.urlFailed)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
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
            if httpResponse.statusCode == 401 {
                throw ServiceError.unauthorized
            } else {
                throw ServiceError.onlineError(Strings.Errors.serverError)
            }
        }

        do {
            let decoder = JSONDecoder()
            let decodedUID = try decoder.decode(DecodedUID.self, from: data)
            return decodedUID.uid
        } catch {
            throw ServiceError.offlineError(Strings.Errors.decodeFailed)
        }
    }
    
    func deleteUser(bearerToken: String) async throws {
        guard let url = URL(string: "\(ServiceUtils.baseUrl)/private/users") else {
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
            if httpResponse.statusCode == 401 {
                throw ServiceError.unauthorized
            } else {
                throw ServiceError.onlineError(Strings.Errors.serverError)
            }
        }
    }
    
}
