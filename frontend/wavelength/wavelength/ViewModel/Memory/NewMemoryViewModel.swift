//
//  NewMemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class NewMemoryViewModel: ObservableObject {
    
    @Published var mid: String = ""
    private var codableMemory = CodableMemory()
    @Published var isLoading = false
    
    @Binding private var memories: [Memory]
    
    @ObservedObject private var user: User
    @ObservedObject private var friend: Friend
    
    init(memories: Binding<[Memory]>, friend: Friend, user: User) {
        self._memories = memories
        self.friend = friend
        self.user = user
    }
    
    private func createMemory(addedTokens: Int) async throws {
        
        print("API CALL: CREATE MEMORIES")

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            let fetchedMID = try await MemoryService.shared.createMemory(newData: codableMemory, fid: friend.fid, bearerToken: bearerToken)
            try await UserService.shared.updateUser(newData: CodableUser(tokenCount: user.tokenCount + addedTokens, memoryCount: user.memoryCount + 1), bearerToken: bearerToken)
            try await FriendService.shared.updateFriend(fid: friend.fid, newData: CodableFriend(tokenCount: friend.tokenCount + addedTokens, memoryCount: friend.memoryCount + 1), bearerToken: bearerToken)
            DispatchQueue.main.async {
                self.mid = fetchedMID
            }
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func completion(memory: Memory, editedMemory: Memory) async throws {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        do {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm E, d MMM y"
            let formattedDate = formatter.string(from: editedMemory.date)
            
            codableMemory.date = formattedDate
            codableMemory.title = editedMemory.title
            codableMemory.content = editedMemory.content
            codableMemory.tokens = editedMemory.tokens
            
            try await createMemory(addedTokens: editedMemory.tokens)
            try await updateScore(user: user, friend: friend)
            
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
