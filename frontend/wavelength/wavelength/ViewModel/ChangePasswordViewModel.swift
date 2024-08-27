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
//    @Published var isLoading = false
//    @Published var updateError: ProfileUpdateError?
    private var isLoading = false
    private var updateError: UpdateError?
    
    private let userService = UserService()
    
    func updatePassword(oldPassword: String, newPassword: String) async throws {
        
        print("API CALL: UPDATE PASSWORD")
        
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        encodedPassword.oldPassword = oldPassword
        encodedPassword.newPassword = newPassword
        
        do {
            try await userService.updatePassword(newData: encodedPassword, bearerToken: bearerToken)
            updateError = nil
            print("User profile updated successfully!")
        } catch {
            if let encodingError = error as? EncodingError {
                updateError = .encodingError(encodingError)
            } else {
                updateError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
}
