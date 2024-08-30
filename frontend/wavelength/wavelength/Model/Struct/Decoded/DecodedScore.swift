//
//  DecodedScore.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import SwiftUI

struct DecodedScore: Decodable {
    
    let sid: String
    let timestamp: String
    let percentage: Int
    let analysis: String?
    
    enum CodingKeys: String, CodingKey {
        case sid
        case timestamp
        case percentage
        case analysis
    }
}
