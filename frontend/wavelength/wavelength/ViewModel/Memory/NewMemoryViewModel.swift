//
//  NewMemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class NewMemoryViewModel {
    
    @Published var mid: String = ""
    private var encodedMemory = EncodedMemory()
//    @Published var isLoading = false
//    @Published var updateError: MemoryUpdateError?
    private var isLoading = false
    private var updateError: MemoryUpdateError?
    
    @Binding private var memories: [Memory]
    
    @ObservedObject private var user: User
    @ObservedObject private var friend: Friend
    
    private let memoryService = MemoryService()
    private let userService = UserService()
    private let friendService = FriendService()
    
    init(memories: Binding<[Memory]>, friend: Friend, user: User) {
        self._memories = memories
        self.friend = friend
        self.user = user
    }
    
    func createMemory(addedTokens: Int) async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            let fetchedMID = try await memoryService.createMemory(newData: encodedMemory, fid: friend.fid, bearerToken: bearerToken)
            try await userService.updateUser(newData: EncodedUser(tokenCount: user.tokenCount + addedTokens, memoryCount: user.memoryCount + 1), bearerToken: bearerToken)
            try await friendService.updateFriend(fid: friend.fid, newData: EncodedFriend(tokenCount: friend.tokenCount + addedTokens, memoryCount: friend.memoryCount + 1), bearerToken: bearerToken)
            updateError = nil
            DispatchQueue.main.async {
                self.mid = fetchedMID
            }
            print("Memory created successfully!")
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
                
                encodedMemory.date = formattedDate
                encodedMemory.title = editedMemory.title
                encodedMemory.content = editedMemory.content
                encodedMemory.tokens = editedMemory.tokens
                
                try await createMemory(addedTokens: editedMemory.tokens)
                
                DispatchQueue.main.async {
                    
                    memory.mid = self.mid
                    memory.date = editedMemory.date
                    memory.title = editedMemory.title
                    memory.content = editedMemory.content
                    memory.tokens = editedMemory.tokens
                    
                    self.memories.append(memory)
                    self.user.memoryCount += 1
                    self.friend.memoryCount += 1
                    self.user.tokenCount += editedMemory.tokens
                    self.friend.tokenCount += editedMemory.tokens
                    
                }
                
            } catch {
                print("Error updating memory: \(error)")
            }
        }
        
    }
    
}
