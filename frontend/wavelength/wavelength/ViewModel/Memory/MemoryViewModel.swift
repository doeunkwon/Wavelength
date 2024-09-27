//
//  MemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI
import SwiftKeychainWrapper

class MemoryViewModel: ObservableObject {
    
    @ObservedObject private var user: User
    @ObservedObject private var friend: Friend
    
    @Binding private var memories: [Memory]
    
    private var codableMemory = CodableMemory()
    @Published var isLoading = false
    
    init(user: User, friend: Friend, memories: Binding<[Memory]>) {
        self.user = user
        self.friend = friend
        self._memories = memories
    }
    
    private func updateMemory(mid: String, oldTokens: Int, newTokens: Int) async throws {
        
        print("API CALL: UPDATE MEMORY")

        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        do {
            try await MemoryService.shared.updateMemory(mid: mid, newData: codableMemory, bearerToken: bearerToken)
            if oldTokens != newTokens {
                try await UserService.shared.updateUser(newData: CodableUser(tokenCount: user.tokenCount - oldTokens + newTokens), bearerToken: bearerToken)
                try await FriendService.shared.updateFriend(fid: friend.fid, newData: CodableFriend(tokenCount: friend.tokenCount - oldTokens + newTokens), bearerToken: bearerToken)
            }
        } catch {
            throw error // Re-throw the error for caller handling
        }
    }
    
    func deleteMemory(mid: String, memoryTokenCount: Int) async throws {
        
        print("API CALL: DELETE MEMORY")
        
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
            
            try await MemoryService.shared.deleteMemory(mid: mid, bearerToken: bearerToken)
            try await FriendService.shared.updateFriend(fid: friend.fid, newData: CodableFriend(tokenCount: friend.tokenCount - memoryTokenCount, memoryCount: friend.memoryCount - 1), bearerToken: bearerToken)
            try await UserService.shared.updateUser(newData: CodableUser(tokenCount: user.tokenCount - memoryTokenCount, memoryCount: user.memoryCount - 1), bearerToken: bearerToken)
            try await updateScore(user: user, friend: friend)
            
            DispatchQueue.main.async {
                
                self.memories.removeAll { $0.mid == mid }
                
                self.user.memoryCount -= 1
                self.user.tokenCount -= memoryTokenCount
                
                self.friend.memoryCount -= 1
                self.friend.tokenCount -= memoryTokenCount
                
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
            let oldTokens = memory.tokens
            let newTokens = editedMemory.tokens
            
            codableMemory.date = memory.date != editedMemory.date ? formattedDate : nil
            codableMemory.title = memory.title != editedMemory.title ? editedMemory.title : nil
            codableMemory.content = memory.content != editedMemory.content ? editedMemory.content : nil
            codableMemory.tokens = oldTokens != newTokens ? newTokens : nil
            
            let shouldUpdateScore = oldTokens != newTokens
            
            try await updateMemory(mid: memory.mid, oldTokens: oldTokens, newTokens: newTokens)
            
            if shouldUpdateScore {
                try await updateScore(user: user, friend: friend)
            }
            
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
