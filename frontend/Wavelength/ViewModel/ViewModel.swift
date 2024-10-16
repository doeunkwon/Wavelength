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
    
    init() {
        isLoggedIn = hasBearerToken()
    }
    
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
            let token = try await AuthenticationService.shared.signIn(username: username, password: password)
            KeychainWrapper.standard.set(token, forKey: "bearerToken")
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
        } catch {
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
            let fetchedUser = try await UserService.shared.getUser(bearerToken: bearerToken)
            let fetchedFriends = try await FriendService.shared.getFriends(bearerToken: bearerToken)
            let fetchedScores = try await ScoreService.shared.getUserScores(bearerToken: bearerToken)
            DispatchQueue.main.async {
                self.user = fetchedUser
                self.scores = fetchedScores
                self.scoreChartData = prepareChartData(from: fetchedScores)
            }
            return fetchedFriends
        } catch {
            throw error
        }
    }
}
