//
//  ContentViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

class ContentViewModel: ObservableObject {
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

    let userService = UserService()
    let friendService = FriendService()
    let scoreService = ScoreService()

    func fetchUser() {
        print("FETCHING USER")
        Task {
            do {
                let fetchedUser = try await userService.fetchUser()
                DispatchQueue.main.async {
                    self.user = fetchedUser
                }
            } catch {
                // Handle error
                print("Error fetching user: \(error)")
            }
        }
    }
    
    func fetchFriends() {
        print("FETCHING FRIENDS")
        Task {
            do {
                let fetchedFriends = try await friendService.fetchFriends()
                DispatchQueue.main.async {
                    self.friends = fetchedFriends
                }
            } catch {
                // Handle error
                print("Error fetching friends: \(error)")
            }
        }
    }
    
    func fetchScores() {
        print("FETCHING SCORES")
        Task {
            do {
                let fetchedScores = try await scoreService.fetchScores()
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
