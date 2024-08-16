//
//  ProfileViewModel.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
}
