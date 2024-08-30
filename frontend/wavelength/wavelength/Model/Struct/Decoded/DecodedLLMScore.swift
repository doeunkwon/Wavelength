//
//  DecodedLLMScore.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI

struct DecodedLLMScore: Decodable {

    let goal: Int
    let value: Int
    let interest: Int
    let memory: Int
    
    enum CodingKeys: String, CodingKey {
        case goal
        case value
        case interest
        case memory
    }
}
