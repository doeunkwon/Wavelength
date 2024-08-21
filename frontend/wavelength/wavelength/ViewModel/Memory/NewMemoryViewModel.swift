//
//  NewMemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class NewMemoryViewModel: ObservableObject {
    
    @Published var encodedMemory = EncodedMemory()
    @Published var isLoading = false
    @Published var updateError: MemoryUpdateError?
    
    @Binding private var memories: [Memory]
    private var fid: String
    
    private let memoryService = MemoryService()
    
    init(memories: Binding<[Memory]>, fid: String) {
        self._memories = memories
        self.fid = fid
    }
    
    func createMemory(fid: String) async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            try await memoryService.createMemory(newData: encodedMemory, fid: fid)
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
                
                try await createMemory(fid: fid)
                
                DispatchQueue.main.async {
                    
                    memory.mid = uuid
                    memory.date = editedMemory.date
                    memory.title = editedMemory.title
                    memory.content = editedMemory.content
                    memory.tokens = editedMemory.tokens
                    
                    self.memories.append(memory)
                    
                }
                
            } catch {
                print("Error updating memory: \(error)")
            }
        }
        
    }
    
}
