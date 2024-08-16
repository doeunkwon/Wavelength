//
//  Profile.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

protocol Profile {
    var emoji: String { get set }
    var color: Color { get set }
    var firstName: String { get set }
    var lastName: String { get set }
    var goals: String { get set }
    var interests: [String] { get set }
    var values: [String] { get set }
    var scorePercentage: Int { get set }
    var tokenCount: Int { get set }
    var memoryCount: Int { get set }
}
