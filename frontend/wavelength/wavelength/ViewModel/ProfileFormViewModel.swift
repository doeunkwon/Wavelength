//
//  ProfileFormViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import Foundation
import Combine

enum ProfileUpdateError: Error {
  case encodingError(Error)
  case networkError(Error)
  case unknownError(String)
}

class ProfileFormViewModel: ObservableObject {

    @Published var user: EncodedUser
    @Published var isLoading = false
    @Published var updateError: ProfileUpdateError?

    private let userService = UserService() // Inject a UserService instance

    init(user: EncodedUser) {
        self.user = user
    }

    func updateUser() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            try await userService.updateUser(newData: user)
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
