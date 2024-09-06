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

    let memoryService = MemoryService()
    
    func getMemories(fid: String, completion: @escaping (Bool) -> Void) {
        
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
                    self.memories = fetchedMemories
                }
                completion(true)
            } catch {
                throw error
            }
        }
    }
}
