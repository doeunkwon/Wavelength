//
//  ChangePasswordViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-25.
//

import SwiftUI
import SwiftKeychainWrapper

class ChangePasswordViewModel: ObservableObject {
    
    private var encodedPassword = EncodedPassword()
    @Published var isLoading = false
    
    private let userService = UserService()
    
    func updatePassword(oldPassword: String, newPassword: String) async throws {
        
        print("API CALL: UPDATE PASSWORD")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        encodedPassword.oldPassword = oldPassword
        encodedPassword.newPassword = newPassword
        
        do {
            try await userService.updatePassword(newData: encodedPassword, bearerToken: bearerToken)
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
}
