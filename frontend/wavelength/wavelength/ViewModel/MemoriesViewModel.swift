//
//  MemoriesViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

class MemoriesViewModel: ObservableObject {
    @Published var memories: [Memory] = []

    let memoryService = MemoryService()
    
    func getMemories(fid: String) {
        print("FETCHING MEMORIES")
        Task {
            do {
                let fetchedMemories = try await memoryService.getMemories(fid: fid)
                DispatchQueue.main.async {
                    self.memories = fetchedMemories
                }
            } catch {
                // Handle error
                print("Error fetching memories: \(error)")
            }
        }
    }
}
