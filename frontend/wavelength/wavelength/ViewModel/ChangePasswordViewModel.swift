//
//  ChangePasswordViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-25.
//

import SwiftUI
import SwiftKeychainWrapper

class ChangePasswordViewModel {
    
    private var encodedPassword = EncodedPassword()
    @Published var isLoading = false
    @Published var updateError: UpdateError?
    
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
            DispatchQueue.main.async {
                self.updateError = nil
            }
        } catch {
            DispatchQueue.main.async {
                if let encodingError = error as? EncodingError {
                    self.updateError = .encodingError(encodingError)
                } else {
                    self.updateError = .networkError(error)
                }
            }
            throw error // Re-throw the error for caller handling
        }
    }
}
