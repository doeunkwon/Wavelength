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
    
    private let friendService = FriendService()
    private let scoreService = ScoreService()
    private let breakdownService = BreakdownService()
    
    @ObservedObject private var friendsManager: FriendsManager
    
    @Binding private var showNewFriendViewModal: Bool
    
    init(friendsManager: FriendsManager, showNewFriendViewModal: Binding<Bool>) {
        self.friendsManager = friendsManager
        self._showNewFriendViewModal = showNewFriendViewModal
    }
    
    func createFriend() async throws {
        
        print("API CALL: CREATE FRIEND")
        
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
            let fetchedFID = try await friendService.createFriend(newData: codableFriend, bearerToken: bearerToken)
            let _ = try await breakdownService.createBreakdown(newData: CodableBreakdown(goal: 0, value: 0, interest: 0, memory: 0), fid: fetchedFID, bearerToken: bearerToken)
            DispatchQueue.main.async {
                self.fid = fetchedFID
            }
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) async throws {
            
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
            }
            
            showNewFriendViewModal.toggle()
        }
        
    }
    
}
