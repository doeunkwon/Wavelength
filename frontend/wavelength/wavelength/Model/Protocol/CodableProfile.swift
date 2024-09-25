//
//  CodableProfile.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-09-25.
//

import SwiftUI

protocol CodableProfile {
    var emoji: String? { get set }
    var color: String? { get set }
    var firstName: String? { get set }
    var lastName: String? { get set }
    var goals: String? { get set }
    var interests: [String]? { get set }
    var values: [String]? { get set }
    var scorePercentage: Int? { get set }
    var tokenCount: Int? { get set }
    var memoryCount: Int? { get set }
}
