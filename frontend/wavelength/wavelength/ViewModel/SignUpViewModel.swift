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
    
    private var codableUser = CodableUser()
    
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
            let fetchedUID = try await userService.createUser(newData: codableUser)
            DispatchQueue.main.async {
                self.uid = fetchedUID
                self.contentToastManager.insertToast(style: .success, message: Strings.Profile.created)
            }
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) async throws {
        
        if let user = profileManager.profile as? User {
            
            let editedProfile = editedProfileManager.profile
            
            codableUser.emoji = editedProfile.emoji
            codableUser.color = editedProfile.color.toHex()
            codableUser.firstName = editedProfile.firstName
            codableUser.lastName = editedProfile.lastName
            codableUser.username = {
                if let editedUser = editedProfile as? User {
                    return editedUser.username
                } else {
                    return nil
                }
                }()
            codableUser.email = {
                if let editedUser = editedProfile as? User {
                    return editedUser.email
                } else {
                    return nil
                }
                }()
            codableUser.password = {
                if let editedUser = editedProfile as? User {
                    return editedUser.password
                } else {
                    return nil
                }
                }()
            codableUser.goals = editedProfile.goals
            codableUser.interests = tagManager.interests
            codableUser.values = tagManager.values
            codableUser.scorePercentage = 0
            codableUser.tokenCount = 0
            codableUser.memoryCount = 0
            
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
