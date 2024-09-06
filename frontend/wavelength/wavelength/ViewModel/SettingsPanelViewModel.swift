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
    @Published var isLoading = false
    @Published var showProfileFormViewSheet = false

    private let userService = UserService()
    
    func updateUser() async throws {
        
        print("API CALL: UPDATE USER")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        do {
            try await userService.updateUser(newData: encodedUser, bearerToken: bearerToken)
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func deleteUser() async throws {
        
        print("API CALL: DELETE USER")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        do {
            try await userService.deleteUser(bearerToken: bearerToken)
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) async throws {
        if let user = profileManager.profile as? User {
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
                
                self.showProfileFormViewSheet.toggle()
                
            }
        }
    }
    
}
