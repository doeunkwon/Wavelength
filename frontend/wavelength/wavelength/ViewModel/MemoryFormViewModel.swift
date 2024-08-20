//
//  MemoryFormViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-19.
//

import Foundation
import Combine

enum MemoryUpdateError: Error {
  case encodingError(Error)
  case networkError(Error)
  case unknownError(String)
}

class MemoryFormViewModel: ObservableObject {

    @Published var memory: EncodedMemory
    @Published var isLoading = false
    @Published var updateError: MemoryUpdateError?

    private let memoryService = MemoryService()

    init(memory: EncodedMemory) {
        self.memory = memory
    }
    
    func updateMemory(mid: String) async throws {
        isLoading = true
        defer { isLoading = false } // Set loading state to false even in case of error

        do {
            try await memoryService.updateMemory(mid: mid, newData: memory)
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
}
