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
    
    init() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environmentObject(viewModel.user)
        }
    }
}
