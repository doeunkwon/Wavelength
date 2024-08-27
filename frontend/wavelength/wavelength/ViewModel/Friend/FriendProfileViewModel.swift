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
    
    private var encodedFriend = EncodedFriend()
//    @Published var isLoading = false
//    @Published var updateError: ProfileUpdateError?
    private var isLoading = false
    private var updateError: UpdateError?
    private var deleteError: DeleteError?
    
    private let friendService = FriendService()
    private let userService = UserService()
    
    init(user: User) {
        self.user = user
    }
    
    func updateFriend(fid: String) async throws {
        
        print("API CALL: UPDATE FRIEND")
        
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            try await friendService.updateFriend(fid: fid, newData: encodedFriend, bearerToken: bearerToken)
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
    
    func deleteFriend(fid: String, friendMemoryCount: Int, friendTokenCount: Int) async throws {
        
        print("API CALL: DELETE FRIEND")
        
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        
        do {
            
            try await friendService.deleteFriend(fid: fid, bearerToken: bearerToken)
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
            
        if let friend = profileManager.profile as? Friend {
            Task {
                do {
                    let editedProfile = editedProfileManager.profile
                    
                    encodedFriend.emoji = friend.emoji != editedProfile.emoji ? editedProfile.emoji : nil
                    encodedFriend.color = friend.color != editedProfile.color ? editedProfile.color.toHex() : nil
                    encodedFriend.firstName = friend.firstName != editedProfile.firstName ? editedProfile.firstName : nil
                    encodedFriend.lastName = friend.lastName != editedProfile.lastName ? editedProfile.lastName : nil
                    encodedFriend.goals = friend.goals != editedProfile.goals ? editedProfile.goals : nil
                    encodedFriend.interests = friend.interests != tagManager.interests ? tagManager.interests : nil
                    encodedFriend.values = friend.values != tagManager.values ? tagManager.values : nil
                    
                    try await updateFriend(fid: friend.fid)
                    
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
