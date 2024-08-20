//
//  SettingsPanelViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class SettingsPanelViewModel {
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) {
            if let user = profileManager.profile as? User {
                Task {
                    do {
                        let editedProfile = editedProfileManager.profile
                        
                        @StateObject var profileFormViewModel = ProfileFormViewModel(
                            profile: EncodedUser(
                                emoji: user.emoji != editedProfile.emoji ? editedProfile.emoji : nil,
                                color: user.color != editedProfile.color ? editedProfile.color.toHex() : nil,
                                firstName: user.firstName != editedProfile.firstName ? editedProfile.firstName : nil,
                                lastName: user.lastName != editedProfile.lastName ? editedProfile.lastName : nil,
                                username: {
                                    if let editedUser = editedProfile as? User {
                                        return user.username != editedUser.username ? editedUser.username : nil
                                    } else {
                                        return nil
                                    }
                                    }(),
                                email: {
                                    if let editedUser = editedProfile as? User {
                                        return user.email != editedUser.email ? editedUser.email : nil
                                    } else {
                                        return nil
                                    }
                                    }(),
                                goals: user.goals != editedProfile.goals ? editedProfile.goals : nil,
                                interests: user.interests != tagManager.interests ? tagManager.interests : nil,
                                values: user.values != tagManager.values ? tagManager.values : nil))
                        
                        try await profileFormViewModel.updateUser()
                        
                        DispatchQueue.main.async {
                            
                            user.emoji = editedProfile.emoji
                            user.color = editedProfile.color
                            user.firstName = editedProfile.firstName
                            user.lastName = editedProfile.lastName
                            if let editedUser = editedProfile as? User {
                                user.username = editedUser.username
                            }
                            if let editedUser = editedProfile as? User {
                                user.email = editedUser.email
                            }
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
