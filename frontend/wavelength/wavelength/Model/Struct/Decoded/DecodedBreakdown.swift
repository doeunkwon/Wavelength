//
//  DecodedBreakdown.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI

struct DecodedBreakdown: Decodable {
    
    let bid: String
    let goal: Int
    let value: Int
    let interest: Int
    let memory: Int
    
    enum CodingKeys: String, CodingKey {
        case bid
        case goal
        case value
        case interest
        case memory
    }
}
