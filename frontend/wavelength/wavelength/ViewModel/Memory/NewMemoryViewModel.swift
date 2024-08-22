//
//  NewMemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class NewMemoryViewModel: ObservableObject {
    
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

        do {
            try await memoryService.createMemory(newData: encodedMemory, fid: friend.fid)
            try await userService.updateUser(newData: EncodedUser(tokenCount: user.tokenCount + addedTokens, memoryCount: user.memoryCount + 1))
            try await friendService.updateFriend(fid: friend.fid, newData: EncodedFriend(tokenCount: friend.tokenCount + addedTokens, memoryCount: friend.memoryCount + 1))
            updateError = nil
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
                
                let uuid = UUID().uuidString
                
                encodedMemory.mid = uuid
                encodedMemory.date = formattedDate
                encodedMemory.title = editedMemory.title
                encodedMemory.content = editedMemory.content
                encodedMemory.tokens = editedMemory.tokens
                
                try await createMemory(addedTokens: editedMemory.tokens)
                
                DispatchQueue.main.async {
                    
                    memory.mid = uuid
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
