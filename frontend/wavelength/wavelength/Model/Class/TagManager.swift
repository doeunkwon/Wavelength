//
//  TagManager.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

class TagManager: ObservableObject {
    
    @Published var values: [String]
    @Published var interests: [String]
    
    func removeValueTag(tag: String) {
        values.removeAll { $0 == tag }
    }
    
    func removeInterestTag(tag: String) {
        interests.removeAll { $0 == tag }
    }
    
    init(values: [String], interests: [String]) {
        self.values = values
        self.interests = interests
    }
}
