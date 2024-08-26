//
//  SignInViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-23.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    
    @Published var bearerToken: String = ""
    
    let authenticationService = AuthenticationService()
    
    func getToken(username: String, password: String) {
        print("FETCHING TOKEN")
        Task {
            do {
                let token = try await authenticationService.signIn(username: username, password: password)
                print(token)
                self.bearerToken = token
                // Navigate to the next view or perform other actions
            } catch {
                // Handle authentication errors
                print("Authentication error:", error.localizedDescription)
            }
        }
    }
}
