//
//  wavelengthApp.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

@main
struct wavelengthApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
