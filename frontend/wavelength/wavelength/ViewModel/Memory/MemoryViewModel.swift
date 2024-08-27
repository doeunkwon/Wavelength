//
//  MemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class MemoryViewModel {
    
    private var encodedMemory = EncodedMemory()
//    @Published var isLoading = false
//    @Published var updateError: MemoryUpdateError?
    private var isLoading = false
    private var updateError: UpdateError?
    
    @ObservedObject private var user: User
    @ObservedObject private var friend: Friend
    
    private let memoryService = MemoryService()
    private let userService = UserService()
    private let friendService = FriendService()
    
    init(user: User, friend: Friend) {
        self.user = user
        self.friend = friend
    }
    
    func updateMemory(mid: String, oldTokens: Int, newTokens: Int) async throws {
        
        print("API CALL: UPDATE MEMORY")
        
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            try await memoryService.updateMemory(mid: mid, newData: encodedMemory, bearerToken: bearerToken)
            if oldTokens != newTokens {
                try await userService.updateUser(newData: EncodedUser(tokenCount: user.tokenCount - oldTokens + newTokens), bearerToken: bearerToken)
                try await friendService.updateFriend(fid: friend.fid, newData: EncodedFriend(tokenCount: friend.tokenCount - oldTokens + newTokens), bearerToken: bearerToken)
            }
            updateError = nil
            print("Memory updated successfully!")
        } catch {
            if let encodingError = error as? EncodingError {
                updateError = .encodingError(encodingError)
            } else {
                updateError = .networkError(error)
            }
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(memory: Memory, editedMemory: Memory) {
        
        Task {
            do {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm E, d MMM y"
                let formattedDate = formatter.string(from: editedMemory.date)
                let oldTokens = memory.tokens
                let newTokens = editedMemory.tokens
                
                encodedMemory.date = memory.date != editedMemory.date ? formattedDate : nil
                encodedMemory.title = memory.title != editedMemory.title ? editedMemory.title : nil
                encodedMemory.content = memory.content != editedMemory.content ? editedMemory.content : nil
                encodedMemory.tokens = oldTokens != newTokens ? newTokens : nil
                
                try await updateMemory(mid: memory.mid, oldTokens: oldTokens, newTokens: newTokens)
                
                DispatchQueue.main.async {
                    
                    memory.date = editedMemory.date
                    memory.title = editedMemory.title
                    memory.content = editedMemory.content
                    memory.tokens = newTokens
                    
                    self.user.tokenCount += (newTokens - oldTokens)
                    self.friend.tokenCount += (newTokens - oldTokens)
                }
                
            } catch {
                print("Error updating memory: \(error)")
            }
        }
        
    }
    
}
