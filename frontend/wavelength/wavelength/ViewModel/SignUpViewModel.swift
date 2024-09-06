//
//  SignUpViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-26.
//

import SwiftUI
import SwiftKeychainWrapper

class SignUpViewModel: ObservableObject {
    
    @Published var uid: String = ""
    @Published var isLoading = false
    
    @ObservedObject private var contentToastManager: ToastManager
    
    @Binding private var showModal: Bool
    
    private var encodedUser = EncodedUser()
    
    private let userService = UserService()
    
    private let login: (String, String) async throws -> ()
    
    init(login: @escaping (String, String) async throws -> (), showModal: Binding<Bool>, contentToastManager: ToastManager) {
        self.login = login
        self._showModal = showModal
        self.contentToastManager = contentToastManager
    }
    
    func createUser() async throws {
        
        print("API CALL: CREATE USER")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        do {
            let fetchedUID = try await userService.createUser(newData: encodedUser)
            DispatchQueue.main.async {
                self.uid = fetchedUID
                self.contentToastManager.insertToast(style: .success, message: Strings.toast.createProfile)
            }
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) async throws {
        
        if let user = profileManager.profile as? User {
            
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
            encodedUser.scorePercentage = 0
            encodedUser.tokenCount = 0
            encodedUser.memoryCount = 0
            
            try await createUser()
            
            DispatchQueue.main.async {
                
                user.uid = self.uid
                user.emoji = editedProfile.emoji
                user.color = editedProfile.color
                user.firstName = editedProfile.firstName
                user.lastName = editedProfile.lastName
                user.goals = editedProfile.goals
                user.interests = tagManager.interests
                user.values = tagManager.values
                user.scorePercentage = 0
                user.tokenCount = 0
                user.memoryCount = 0
                
            }
            
            showModal.toggle()
        }
        
    }
    
}
