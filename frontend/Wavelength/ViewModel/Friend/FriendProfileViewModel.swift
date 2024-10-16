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
    
    @Published var isLoading = false
    @Published var showProfileFormViewSheet = false
    
    private let friends: [Friend]
    
    private var codableFriend = CodableFriend()
    
    init(user: User, friend: Friend, friends: [Friend]) {
        self.user = user
        self.friend = friend
        self.friends = friends
    }
    
    private func updateFriend(fid: String) async throws {
        
        print("API CALL: UPDATE FRIEND")

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            try await FriendService.shared.updateFriend(fid: fid, newData: codableFriend, bearerToken: bearerToken)
            
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func deleteFriend(fid: String, friendMemoryCount: Int, friendTokenCount: Int) async throws {
        
        print("API CALL: DELETE FRIEND")
        
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
            
            let friendsScoreSum = friends.reduce(0) { $0 + $1.scorePercentage }
            
            let friendScore = friend.scorePercentage
            
            let newUserScore = friends.count - 1 == 0 ? 0 : (friendsScoreSum - friendScore) / (friends.count - 1)
            
            try await FriendService.shared.deleteFriend(fid: fid, bearerToken: bearerToken)
            _ = try await ScoreService.shared.createUserScore(newData: CodableScore(percentage: newUserScore), bearerToken: bearerToken)
            try await UserService.shared.updateUser(newData: CodableUser(scorePercentage: newUserScore, tokenCount: user.tokenCount - friendTokenCount, memoryCount: user.memoryCount - friendMemoryCount), bearerToken: bearerToken)
            
            DispatchQueue.main.async {
                
                self.user.scorePercentage = newUserScore
                self.user.memoryCount -= friendMemoryCount
                self.user.tokenCount -= friendTokenCount
                
            }
            
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) async throws {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
            
        if let friend = profileManager.profile as? Friend {
            let editedProfile = editedProfileManager.profile
            
            codableFriend.emoji = friend.emoji != editedProfile.emoji ? editedProfile.emoji : nil
            codableFriend.color = friend.color != editedProfile.color ? editedProfile.color.toHex() : nil
            codableFriend.firstName = friend.firstName != editedProfile.firstName ? editedProfile.firstName : nil
            codableFriend.lastName = friend.lastName != editedProfile.lastName ? editedProfile.lastName : nil
            codableFriend.goals = friend.goals != editedProfile.goals ? editedProfile.goals : nil
            codableFriend.interests = friend.interests != tagManager.interests ? tagManager.interests : nil
            codableFriend.values = friend.values != tagManager.values ? tagManager.values : nil
            
            let shouldUpdateScore = friend.goals != editedProfile.goals || friend.interests != tagManager.interests || friend.values != tagManager.values
            
            try await updateFriend(fid: friend.fid)
            
            if shouldUpdateScore {
                try await updateScore(user: user, friend: friend)
            }
            
            DispatchQueue.main.async {
                
                friend.emoji = editedProfile.emoji
                friend.color = editedProfile.color
                friend.firstName = editedProfile.firstName
                friend.lastName = editedProfile.lastName
                friend.goals = editedProfile.goals
                friend.interests = tagManager.interests
                friend.values = tagManager.values
                
                self.showProfileFormViewSheet.toggle()
            }
        }
        
    }
    
}
