//
//  wavelengthApp.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

@main
struct wavelengthApp: App {
    var body: some Scene {
        
        @StateObject var viewModel = ViewModel()
        
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
