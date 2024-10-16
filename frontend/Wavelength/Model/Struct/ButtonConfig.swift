//
//  ProfileFormTrailingButtonConfig.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-20.
//

import SwiftUI

struct ProfileFormTrailingButtonConfig {
    let title: String
    let action: (ProfileManager, ProfileManager, TagManager) async throws -> Void
}

struct MemoryFormTrailingButtonConfig {
    let title: String
    let action: (Memory, Memory) async throws -> Void
}
