//
//  NewMemoryViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

class NewMemoryViewModel {
    
    @Binding private var memories: [Memory]
    private var fid: String
    
    init(memories: Binding<[Memory]>, fid: String) {
        self._memories = memories
        self.fid = fid
    }
    
    func completion(memory: Memory, editedMemory: Memory) {
        
        Task {
            do {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm E, d MMM y"
                let formattedDate = formatter.string(from: editedMemory.date)
                
                let uuid = UUID().uuidString
                
                @StateObject var memoryFormViewModel = MemoryFormViewModel(memory: EncodedMemory(
                    mid: uuid,
                    date: formattedDate,
                    title: editedMemory.title,
                    content: editedMemory.content,
                    tokens: editedMemory.tokens)
                )
                
                try await memoryFormViewModel.createMemory(fid: fid)
                
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
