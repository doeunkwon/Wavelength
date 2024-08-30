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
    @Published var updateError: UpdateError?
    
    private let friends: [Friend]
    
    private var encodedFriend = EncodedFriend()
    private var deleteError: DeleteError?
    
    private let friendService = FriendService()
    private let userService = UserService()
    private let llmService = LLMService()
    private let breakdownService = BreakdownService()
    private let scoreService = ScoreService()
    
    init(user: User, friend: Friend, friends: [Friend]) {
        self.user = user
        self.friend = friend
        self.friends = friends
    }
    
    func updateScore(fid: String) async throws {
        
        print("API CALL: UPDATE FRIEND")
        
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
            
            let llmScore: LLMScore = try await llmService.generateLLMScore(fid: fid, bearerToken: bearerToken)
            
            let goalScore = llmScore.goal
            let valueScore = llmScore.value
            let interestScore = llmScore.interest
            let memoryScore = llmScore.memory
            
            let newFriendScore = (goalScore + valueScore + interestScore + memoryScore) / 4
            
            let filteredFriendsCount = friends.filter { $0.scorePercentage >= 0 }.count
            
            let userScore = user.scorePercentage
            let oldFriendScore = friend.scorePercentage
            
            var newUserScore = 0
            
            if oldFriendScore >= 0 {
                newUserScore = userScore - (oldFriendScore / filteredFriendsCount) + (newFriendScore / filteredFriendsCount)
            } else {
                newUserScore = ((userScore * filteredFriendsCount) + newFriendScore) / (filteredFriendsCount + 1)
            }
            
            _ = try await scoreService.createUserScore(newData: EncodedScore(percentage: newUserScore), bearerToken: bearerToken)
            _ = try await scoreService.createFriendScore(newData: EncodedScore(percentage: newFriendScore, analysis: ""), fid: fid, bearerToken: bearerToken)
            _ = try await breakdownService.updateBreakdown(fid: friend.fid, newData: EncodedBreakdown(goal:goalScore, value: valueScore, interest: interestScore, memory: memoryScore), bearerToken: bearerToken)
            try await friendService.updateFriend(fid: fid, newData: EncodedFriend(scorePercentage: newFriendScore), bearerToken: bearerToken)
            try await userService.updateUser(newData: EncodedUser(scorePercentage: newUserScore), bearerToken: bearerToken)
            
            DispatchQueue.main.async {
                
                self.updateError = nil
                self.friend.scorePercentage = newFriendScore
                self.user.scorePercentage = newUserScore
                
            }
        } catch {
            DispatchQueue.main.async {
                if let encodingError = error as? EncodingError {
                    self.updateError = .encodingError(encodingError)
                } else {
                    self.updateError = .networkError(error)
                }
            }
            throw error // Re-throw the error for caller handling
        }
    }

    
    func updateFriend(fid: String) async throws {
        
        print("API CALL: UPDATE FRIEND")
        
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
            try await friendService.updateFriend(fid: fid, newData: encodedFriend, bearerToken: bearerToken)
            
            DispatchQueue.main.async {
                self.updateError = nil
            }
            
        } catch {
            DispatchQueue.main.async {
                if let encodingError = error as? EncodingError {
                    self.updateError = .encodingError(encodingError)
                } else {
                    self.updateError = .networkError(error)
                }
            }
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
            
            try await friendService.deleteFriend(fid: fid, bearerToken: bearerToken)
            try await userService.updateUser(newData: EncodedUser(tokenCount: user.tokenCount - friendTokenCount, memoryCount: user.memoryCount - friendMemoryCount), bearerToken: bearerToken)
            
            DispatchQueue.main.async {
                
                self.user.memoryCount -= friendMemoryCount
                self.user.tokenCount -= friendTokenCount
                
            }
            
            deleteError = nil
        } catch {
            DispatchQueue.main.async {
                if let encodingError = error as? EncodingError {
                    self.deleteError = .encodingError(encodingError)
                } else {
                    self.deleteError = .networkError(error)
                }
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
