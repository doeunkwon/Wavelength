//
//  SignUpViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-26.
//

import SwiftUI

import SwiftUI
import SwiftKeychainWrapper

class SignUpViewModel: ObservableObject {
    
    @Published var uid: String = ""
    
    @Binding private var showModal: Bool
    
    private var encodedUser = EncodedUser()
//    @Published var isLoading = false
//    @Published var updateError: ProfileUpdateError?
    private var isLoading = false
    private var updateError: ProfileUpdateError?
    
    private let userService = UserService()
    
    private let login: (String, String) -> Void
    
    init(login: @escaping (String, String) -> Void, showModal: Binding<Bool>) {
        self.login = login
        self._showModal = showModal
    }
    
    func createFriend() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            let fetchedUID = try await userService.createUser(newData: encodedUser)
            updateError = nil
            DispatchQueue.main.async {
                self.uid = fetchedUID
            }
            print("User profile created successfully!")
        } catch {
            if let encodingError = error as? EncodingError {
                updateError = .encodingError(encodingError)
            } else {
                updateError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) {
        
        if let user = profileManager.profile as? User {
            Task {
                do {
                    
                    let editedProfile = editedProfileManager.profile
                    
                    encodedUser.emoji = editedProfile.emoji
                    encodedUser.color = editedProfile.color.toHex()
                    encodedUser.firstName = editedProfile.firstName
                    encodedUser.lastName = editedProfile.lastName
                    encodedUser.username = {
                        if let editedUser = editedProfile as? User {
                            return editedUser.username
                        } else {
                            return nil
                        }
                        }()
                    encodedUser.email = {
                        if let editedUser = editedProfile as? User {
                            return editedUser.email
                        } else {
                            return nil
                        }
                        }()
                    encodedUser.password = {
                        if let editedUser = editedProfile as? User {
                            return editedUser.password
                        } else {
                            return nil
                        }
                        }()
                    encodedUser.goals = editedProfile.goals
                    encodedUser.interests = tagManager.interests
                    encodedUser.values = tagManager.values
                    encodedUser.scorePercentage = 50
                    encodedUser.tokenCount = 0
                    encodedUser.memoryCount = 0
                    
                    try await createFriend()
                    
                    DispatchQueue.main.async {
                        
                        user.uid = self.uid
                        user.emoji = editedProfile.emoji
                        user.color = editedProfile.color
                        user.firstName = editedProfile.firstName
                        user.lastName = editedProfile.lastName
                        user.goals = editedProfile.goals
                        user.interests = tagManager.interests
                        user.values = tagManager.values
                        user.scorePercentage = 50
                        user.tokenCount = 0
                        user.memoryCount = 0
                        
                        self.showModal.toggle()
                        
                    }
                    
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
        
    }
    
}
