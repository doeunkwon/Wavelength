//
//  FriendProfileViewModel.swift.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class FriendProfileViewModel: ObservableObject {
    
    @ObservedObject private var user: User
    @ObservedObject private var friend: Friend
    
    private var encodedFriend = EncodedFriend()
//    @Published var isLoading = false
//    @Published var updateError: ProfileUpdateError?
    private var isLoading = false
    private var updateError: UpdateError?
    private var deleteError: DeleteError?
    
    private let friendService = FriendService()
    private let userService = UserService()
    
    init(friend: Friend, user: User) {
        self.friend = friend
        self.user = user
    }
    
    func updateFriend() async throws {
        
        print("API CALL: UPDATE FRIEND")
        
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            try await friendService.updateFriend(fid: friend.fid, newData: encodedFriend, bearerToken: bearerToken)
            updateError = nil
            print("Friend profile updated successfully!")
        } catch {
            if let encodingError = error as? EncodingError {
                updateError = .encodingError(encodingError)
            } else {
                updateError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
    
    func deleteFriend() async throws {
        
        print("API CALL: DELETE FRIEND")
        
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        do {
            
            let friendMemoryCount = friend.memoryCount
            let friendTokenCount = friend.tokenCount
            
            try await friendService.deleteFriend(fid: friend.fid, bearerToken: bearerToken)
            try await userService.updateUser(newData: EncodedUser(tokenCount: user.tokenCount - friendTokenCount, memoryCount: user.memoryCount - friendMemoryCount), bearerToken: bearerToken)
            
            DispatchQueue.main.async {
                
                self.user.memoryCount -= friendMemoryCount
                self.user.tokenCount -= friendTokenCount
                
            }
            
            deleteError = nil
            print("Friend profile deleted successfully!")
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
            
        if let friendPM = profileManager.profile as? Friend {
            Task {
                do {
                    let editedProfile = editedProfileManager.profile
                    
                    encodedFriend.emoji = friendPM.emoji != editedProfile.emoji ? editedProfile.emoji : nil
                    encodedFriend.color = friendPM.color != editedProfile.color ? editedProfile.color.toHex() : nil
                    encodedFriend.firstName = friendPM.firstName != editedProfile.firstName ? editedProfile.firstName : nil
                    encodedFriend.lastName = friendPM.lastName != editedProfile.lastName ? editedProfile.lastName : nil
                    encodedFriend.goals = friendPM.goals != editedProfile.goals ? editedProfile.goals : nil
                    encodedFriend.interests = friendPM.interests != tagManager.interests ? tagManager.interests : nil
                    encodedFriend.values = friendPM.values != tagManager.values ? tagManager.values : nil
                    
                    try await updateFriend()
                    
                    DispatchQueue.main.async {
                        
                        friendPM.emoji = editedProfile.emoji
                        friendPM.color = editedProfile.color
                        friendPM.firstName = editedProfile.firstName
                        friendPM.lastName = editedProfile.lastName
                        friendPM.goals = editedProfile.goals
                        friendPM.interests = tagManager.interests
                        friendPM.values = tagManager.values
                    }
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
        
    }
    
}
