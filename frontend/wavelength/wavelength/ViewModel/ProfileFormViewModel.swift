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

    @Published var profile: EncodedProfile
    @Published var isLoading = false
    @Published var updateError: ProfileUpdateError?

    private let userService = UserService()
    private let friendService = FriendService()

    init(profile: EncodedProfile) {
        self.profile = profile
    }

    func updateUser() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            if let user = profile as? EncodedUser {
                try await userService.updateUser(newData: user)
                updateError = nil
                print("User profile updated successfully!")
            }
        } catch {
            if let encodingError = error as? EncodingError {
                updateError = .encodingError(encodingError)
            } else {
                updateError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
    
    func updateFriend(fid: String) async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            if let friend = profile as? EncodedFriend {
                try await friendService.updateFriend(fid: fid, newData: friend)
                updateError = nil
                print("Friend profile updated successfully!")
            }
        } catch {
            if let encodingError = error as? EncodingError {
                updateError = .encodingError(encodingError)
            } else {
                updateError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
    
    func createFriend() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            if let friend = profile as? EncodedFriend {
                try await friendService.createFriend(newData: friend)
                updateError = nil
                print("Friend profile created successfully!")
            }
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
