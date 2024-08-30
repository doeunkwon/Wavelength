//
//  MemoriesViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI
import SwiftKeychainWrapper

class MemoriesViewModel: ObservableObject {
    @Published var memories: [Memory] = []
    @Published var isLoading = false
    @Published var readError: ReadError?

    let memoryService = MemoryService()
    
    func getMemories(fid: String) {
        
        print("API CALL: GET MEMORIES")
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        let bearerToken = KeychainWrapper.standard.string(forKey: "bearerToken") ?? ""
        Task {
            do {
                let fetchedMemories = try await memoryService.getMemories(fid: fid, bearerToken: bearerToken)
                DispatchQueue.main.async {
                    self.readError = nil
                    self.memories = fetchedMemories
                }
            } catch {
                DispatchQueue.main.async {
                    if let encodingError = error as? EncodingError {
                        self.readError = .encodingError(encodingError)
                    } else {
                        self.readError = .networkError(error)
                    }
                }
            }
        }
    }
}
