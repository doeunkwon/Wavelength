//
//  NewFriendViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class NewFriendViewModel: ObservableObject {
    
    @Published var encodedFriend = EncodedFriend()
    @Published var isLoading = false
    @Published var updateError: ProfileUpdateError?
    
    private let friendService = FriendService()
    
    @Binding private var friends: [Friend]
    
    init(friends: Binding<[Friend]>) {
        self._friends = friends
    }
    
    func createFriend() async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            try await friendService.createFriend(newData: encodedFriend)
            updateError = nil
            print("Friend profile created successfully!")
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
            
        if let friend = profileManager.profile as? Friend {
            Task {
                do {
                    
                    let editedProfile = editedProfileManager.profile
                    let uuid = UUID().uuidString
                    
                    encodedFriend.fid = uuid
                    encodedFriend.emoji = editedProfile.emoji
                    encodedFriend.color = editedProfile.color.toHex()
                    encodedFriend.firstName = editedProfile.firstName
                    encodedFriend.lastName = editedProfile.lastName
                    encodedFriend.goals = editedProfile.goals
                    encodedFriend.interests = tagManager.interests
                    encodedFriend.values = tagManager.values
                    encodedFriend.scorePercentage = 50
                    encodedFriend.scoreAnalysis = ""
                    encodedFriend.tokenCount = 0
                    encodedFriend.memoryCount = 0
                    
                    try await createFriend()
                    
                    DispatchQueue.main.async {
                        
                        friend.fid = uuid
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
                        
                        self.friends.append(friend)
                    }
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
        
    }
    
}
