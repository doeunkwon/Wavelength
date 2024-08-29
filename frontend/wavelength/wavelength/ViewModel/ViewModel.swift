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
    @Published var friends: [Friend] = []
    @Published var scores: [Score] = []
    @Published var scoreChartData: [ScoreData] = []
    
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
    
    func getToken(username: String, password: String) {
        print("API CALL: GET TOKEN")
        Task {
            do {
                let token = try await authenticationService.signIn(username: username, password: password)
                KeychainWrapper.standard.set(token, forKey: "bearerToken")
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            } catch {
                // Handle authentication errors
                print("Authentication error:", error.localizedDescription)
            }
        }
    }

    func getUser() {
        print("API CALL: GET USER")
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        Task {
            do {
                let fetchedUser = try await userService.getUser(bearerToken: bearerToken)
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            } catch {
                // Handle error
                print("Error fetching user: \(error)")
            }
        }
    }
    
    func getFriends() {
        print("API CALL: GET FRIENDS")
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        Task {
            do {
                let fetchedFriends = try await friendService.getFriends(bearerToken: bearerToken)
                DispatchQueue.main.async {
                    self.friends = fetchedFriends
                }
            } catch {
                // Handle error
                print("Error fetching friends: \(error)")
            }
        }
    }
    
    func getUserScores() {
        print("API CALL: GET USER SCORES")
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        Task {
            do {
                let fetchedScores = try await scoreService.getUserScores(bearerToken: bearerToken)
                DispatchQueue.main.async {
                    self.scores = fetchedScores
                    self.scoreChartData = prepareChartData(from: fetchedScores)
                }
            } catch {
                // Handle error
                print("Error fetching scores: \(error)")
            }
        }
    }
}
