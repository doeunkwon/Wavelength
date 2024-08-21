//
//  MemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class MemoryViewModel {
    
    func completion(memory: Memory, editedMemory: Memory) {
        
        Task {
            do {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm E, d MMM y"
                let formattedDate = formatter.string(from: editedMemory.date)
                
                @StateObject var memoryFormViewModel = MemoryFormViewModel(memory: EncodedMemory(
                    date: memory.date != editedMemory.date ? formattedDate : nil,
                    title: memory.title != editedMemory.title ? editedMemory.title : nil,
                    content: memory.content != editedMemory.content ? editedMemory.content : nil,
                    tokens: memory.tokens != editedMemory.tokens ? editedMemory.tokens : nil)
                )
                
                try await memoryFormViewModel.updateMemory(mid: memory.mid)
                
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
