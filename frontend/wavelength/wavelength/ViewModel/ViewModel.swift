//
//  ViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

class ViewModel: ObservableObject {
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

    func getUser() {
        print("FETCHING USER")
        Task {
            do {
                let fetchedUser = try await userService.getUser()
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
        print("FETCHING FRIENDS")
        Task {
            do {
                let fetchedFriends = try await friendService.getFriends()
                DispatchQueue.main.async {
                    self.friends = fetchedFriends
                }
            } catch {
                // Handle error
                print("Error fetching friends: \(error)")
            }
        }
    }
    
    func getScores() {
        print("FETCHING SCORES")
        Task {
            do {
                let fetchedScores = try await scoreService.getScores()
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
