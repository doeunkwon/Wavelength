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
    @Published var updateError: UpdateError?
    private var encodedFriend = EncodedFriend()
    
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
            let fetchedFID = try await friendService.createFriend(newData: encodedFriend, bearerToken: bearerToken)
            let _ = try await breakdownService.createBreakdown(newData: EncodedBreakdown(goal: 0, value: 0, interest: 0, memory: 0), fid: fetchedFID, bearerToken: bearerToken)
            DispatchQueue.main.async {
                self.updateError = nil
                self.fid = fetchedFID
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
    
    func completion(profileManager: ProfileManager, editedProfileManager: ProfileManager, tagManager: TagManager) {
            
        if let friend = profileManager.profile as? Friend {
            Task {
                do {
                    
                    let editedProfile = editedProfileManager.profile
                    
                    encodedFriend.emoji = editedProfile.emoji
                    encodedFriend.color = editedProfile.color.toHex()
                    encodedFriend.firstName = editedProfile.firstName
                    encodedFriend.lastName = editedProfile.lastName
                    encodedFriend.goals = editedProfile.goals
                    encodedFriend.interests = tagManager.interests
                    encodedFriend.values = tagManager.values
                    encodedFriend.scorePercentage = -1
                    encodedFriend.scoreAnalysis = ""
                    encodedFriend.tokenCount = 0
                    encodedFriend.memoryCount = 0
                    
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
                } catch {
                  // Handle errors
                    print("Error updating user: \(error)")
                }
            }
        }
        
    }
    
}
