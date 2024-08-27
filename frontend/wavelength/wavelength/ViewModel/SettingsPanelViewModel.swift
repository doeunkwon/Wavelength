//
//  SettingsPanelViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class SettingsPanelViewModel: ObservableObject {
    
    private var encodedUser = EncodedUser()
//    @Published var isLoading = false
//    @Published var updateError: ProfileUpdateError?
    private var isLoading = false
    private var updateError: UpdateError?
    private var deleteError: DeleteError?

    private let userService = UserService()
    
    func updateUser() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        do {
            try await userService.updateUser(newData: encodedUser, bearerToken: bearerToken)
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
    
    func deleteUser() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        do {
            try await userService.deleteUser(bearerToken: bearerToken)
            deleteError = nil
            print("User profile deleted successfully!")
        } catch {
            if let encodingError = error as? EncodingError {
                deleteError = .encodingError(encodingError)
            } else {
                deleteError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) {
        if let user = profileManager.profile as? User {
            Task {
                do {
                    let editedProfile = editedProfileManager.profile
                    
                    encodedUser.emoji = user.emoji != editedProfile.emoji ? editedProfile.emoji : nil
                    encodedUser.color = user.color != editedProfile.color ? editedProfile.color.toHex() : nil
                    encodedUser.firstName = user.firstName != editedProfile.firstName ? editedProfile.firstName : nil
                    encodedUser.lastName = user.lastName != editedProfile.lastName ? editedProfile.lastName : nil
//                    encodedUser.username = {
//                        if let editedUser = editedProfile as? User {
//                            return user.username != editedUser.username ? editedUser.username : nil
//                        } else {
//                            return nil
//                        }
//                        }()
//                    encodedUser.email = {
//                        if let editedUser = editedProfile as? User {
//                            return user.email != editedUser.email ? editedUser.email : nil
//                        } else {
//                            return nil
//                        }
//                        }()
                    encodedUser.goals = user.goals != editedProfile.goals ? editedProfile.goals : nil
                    encodedUser.interests = user.interests != tagManager.interests ? tagManager.interests : nil
                    encodedUser.values = user.values != tagManager.values ? tagManager.values : nil
                    
                    try await updateUser()
                    
                    DispatchQueue.main.async {
                        
                        user.emoji = editedProfile.emoji
                        user.color = editedProfile.color
                        user.firstName = editedProfile.firstName
                        user.lastName = editedProfile.lastName
//                        if let editedUser = editedProfile as? User {
//                            user.username = editedUser.username
//                        }
//                        if let editedUser = editedProfile as? User {
//                            user.email = editedUser.email
//                        }
                        user.goals = editedProfile.goals
                        user.interests = tagManager.interests
                        user.values = tagManager.values
                        
                    }
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
    }
    
}
