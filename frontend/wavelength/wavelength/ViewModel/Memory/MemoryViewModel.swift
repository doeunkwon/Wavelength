//
//  MemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class MemoryViewModel: ObservableObject {
    
    @Published var encodedMemory = EncodedMemory()
    @Published var isLoading = false
    @Published var updateError: MemoryUpdateError?
    
    private let memoryService = MemoryService()
    
    func updateMemory(mid: String) async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            try await memoryService.updateMemory(mid: mid, newData: encodedMemory)
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
                
                encodedMemory.date = memory.date != editedMemory.date ? formattedDate : nil
                encodedMemory.title = memory.title != editedMemory.title ? editedMemory.title : nil
                encodedMemory.content = memory.content != editedMemory.content ? editedMemory.content : nil
                encodedMemory.tokens = memory.tokens != editedMemory.tokens ? editedMemory.tokens : nil
                
                try await updateMemory(mid: memory.mid)
                
                DispatchQueue.main.async {
                    
                    memory.date = editedMemory.date
                    memory.title = editedMemory.title
                    memory.content = editedMemory.content
                    memory.tokens = editedMemory.tokens
                }
                
            } catch {
                print("Error updating memory: \(error)")
            }
        }
        
    }
    
}
