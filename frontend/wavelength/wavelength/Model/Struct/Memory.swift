//
//  Memory.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct Memory: Hashable {
    
    let mid: String
    let date: Date
    let title: String
    let content: String
    let tokens: Int
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(mid)
        }
}
