//
//  NewFriendViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class NewFriendViewModel: ObservableObject {
    
    @Published var fid: String = ""
    @Published var isLoading = false
    private var codableFriend = CodableFriend()
    
    @ObservedObject private var friendsManager: FriendsManager
    
    @Binding private var showNewFriendViewModal: Bool
    
    private var user: User
    
    init(friendsManager: FriendsManager, showNewFriendViewModal: Binding<Bool>, user: User) {
        self.friendsManager = friendsManager
        self._showNewFriendViewModal = showNewFriendViewModal
        self.user = user
    }
    
    private func createFriend() async throws {
        
        print("API CALL: CREATE FRIEND")

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            let fetchedFID = try await FriendService.shared.createFriend(newData: codableFriend, bearerToken: bearerToken)
            let _ = try await BreakdownService.shared.createBreakdown(newData: CodableBreakdown(goal: 0, value: 0, interest: 0, memory: 0), fid: fetchedFID, bearerToken: bearerToken)
            DispatchQueue.main.async {
                self.fid = fetchedFID
            }
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) async throws {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
            
        if let friend = profileManager.profile as? Friend {
            let editedProfile = editedProfileManager.profile
            
            codableFriend.emoji = editedProfile.emoji
            codableFriend.color = editedProfile.color.toHex()
            codableFriend.firstName = editedProfile.firstName
            codableFriend.lastName = editedProfile.lastName
            codableFriend.goals = editedProfile.goals
            codableFriend.interests = tagManager.interests
            codableFriend.values = tagManager.values
            codableFriend.scorePercentage = -1
            codableFriend.scoreAnalysis = ""
            codableFriend.tokenCount = 0
            codableFriend.memoryCount = 0
            
            try await createFriend()
            
            DispatchQueue.main.async {
                
                friend.fid = self.fid
                friend.emoji = editedProfile.emoji
                friend.color = editedProfile.color
                friend.firstName = editedProfile.firstName
                friend.lastName = editedProfile.lastName
                friend.goals = editedProfile.goals
                friend.interests = tagManager.interests
                friend.values = tagManager.values
                friend.scorePercentage = -1
                friend.scoreAnalysis = ""
                friend.tokenCount = 0
                friend.memoryCount = 0
                
                self.friendsManager.addFriend(friend: friend)
                
                DispatchQueue.global(qos: .userInteractive).async {
                    Task {
                        try await updateScore(user: self.user, friend: friend)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.showNewFriendViewModal.toggle()
                        }
                    }
                }
                
            }
            
        }
        
    }
    
}
