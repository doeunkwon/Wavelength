//
//  FriendProfileViewModel.swift.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class FriendProfileViewModel {
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) {
            
        if let friend = profileManager.profile as? Friend {
            Task {
                do {
                    let editedProfile = editedProfileManager.profile
                    
                    @StateObject var profileFormViewModel = ProfileFormViewModel(
                        profile: EncodedFriend(
                            emoji: friend.emoji != editedProfile.emoji ? editedProfile.emoji : nil,
                            color: friend.color != editedProfile.color ? editedProfile.color.toHex() : nil,
                            firstName: friend.firstName != editedProfile.firstName ? editedProfile.firstName : nil,
                            lastName: friend.lastName != editedProfile.lastName ? editedProfile.lastName : nil,
                            goals: friend.goals != editedProfile.goals ? editedProfile.goals : nil,
                            interests: friend.interests != tagManager.interests ? tagManager.interests : nil,
                            values: friend.values != tagManager.values ? tagManager.values : nil))
                    
                    try await profileFormViewModel.updateFriend(fid: friend.fid)
                    
                    DispatchQueue.main.async {
                        
                        friend.emoji = editedProfile.emoji
                        friend.color = editedProfile.color
                        friend.firstName = editedProfile.firstName
                        friend.lastName = editedProfile.lastName
                        friend.goals = editedProfile.goals
                        friend.interests = tagManager.interests
                        friend.values = tagManager.values
                    }
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
        
    }
    
}
