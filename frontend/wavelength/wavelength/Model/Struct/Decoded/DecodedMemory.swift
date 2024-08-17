//
//  DecodedMemory.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

struct DecodedMemory: Decodable {
    
    let mid: String
    let date: String
    let title: String
    let content: String
    let tokens: Int
    
    enum CodingKeys: String, CodingKey {
        case mid
        case date
        case title
        case content
        case tokens
    }
}
