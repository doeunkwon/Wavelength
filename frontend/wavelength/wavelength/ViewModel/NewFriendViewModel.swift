//
//  NewFriendViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class NewFriendViewModel {
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) {
            
        if let friend = profileManager.profile as? Friend {
            Task {
                do {
                    let editedProfile = editedProfileManager.profile
                    
                    @StateObject var profileFormViewModel = ProfileFormViewModel(
                        profile: EncodedFriend(
                            fid: UUID().uuidString,
                            emoji: editedProfile.emoji,
                            color: editedProfile.color.toHex(),
                            firstName: editedProfile.firstName,
                            lastName: editedProfile.lastName,
                            goals: editedProfile.goals,
                            interests: tagManager.interests,
                            values: tagManager.values,
                            scorePercentage: 50,
                            scoreAnalysis: "",
                            tokenCount: 0,
                            memoryCount: 0)
                    )
                    
                    try await profileFormViewModel.createFriend()
                    
                    DispatchQueue.main.async {
                        
                        friend.emoji = editedProfile.emoji
                        friend.color = editedProfile.color
                        friend.firstName = editedProfile.firstName
                        friend.lastName = editedProfile.lastName
                        friend.goals = editedProfile.goals
                        friend.interests = tagManager.interests
                        friend.values = tagManager.values
                        friend.scorePercentage = 50
                        friend.scoreAnalysis = ""
                        friend.tokenCount = 0
                        friend.memoryCount = 0
                    }
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
        
    }
    
}
