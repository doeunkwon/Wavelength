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

    let userService = UserService()

    func fetchUser() {
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
}
