//
//  ViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI
import SwiftKeychainWrapper

class ViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var user: User = User(
        uid: "",
        emoji: "",
        color: .clear,
        firstName: "",
        lastName: "",
        username: "",
        email: "",
        password: "",
        goals: "",
        interests: [],
        scorePercentage: 0,
        tokenCount: 0,
        memoryCount: 0,
        values: [])
    @Published var scores: [Score] = []
    @Published var scoreChartData: [ScoreData] = []
    @Published var isLoading = false
    @Published var readError: ReadError?
    
    init() {
        isLoggedIn = hasBearerToken()
    }

    let authenticationService = AuthenticationService()
    let userService = UserService()
    let friendService = FriendService()
    let scoreService = ScoreService()
    
    func hasBearerToken() -> Bool {
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        return bearerToken != ""
    }
    
    func getToken(username: String, password: String) async throws {
        
        print("API CALL: GET TOKEN")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        do {
            let token = try await authenticationService.signIn(username: username, password: password)
            KeychainWrapper.standard.set(token, forKey: "bearerToken")
            DispatchQueue.main.async {
                self.readError = nil
                self.isLoggedIn = true
            }
        } catch {
            DispatchQueue.main.async {
                if let encodingError = error as? EncodingError {
                    self.readError = .encodingError(encodingError)
                } else {
                    self.readError = .networkError(error)
                }
            }
            throw error
        }
    }

    func getUserInfo() async throws -> [Friend] {
        
        print("API CALL: GET USER")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            let fetchedUser = try await userService.getUser(bearerToken: bearerToken)
            let fetchedFriends = try await friendService.getFriends(bearerToken: bearerToken)
            let fetchedScores = try await scoreService.getUserScores(bearerToken: bearerToken)
            DispatchQueue.main.async {
                self.readError = nil
                self.user = fetchedUser
                self.scores = fetchedScores
                self.scoreChartData = prepareChartData(from: fetchedScores)
            }
            return fetchedFriends
        } catch {
            DispatchQueue.main.async {
                if let encodingError = error as? EncodingError {
                    self.readError = .encodingError(encodingError)
                } else {
                    self.readError = .networkError(error)
                }
            }
            throw error
        }
    }
}
