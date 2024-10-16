//
//  Breakdown.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI

class Breakdown: ObservableObject {
    
    let bid: String
    @Published var goal: Int
    @Published var value: Int
    @Published var interest: Int
    @Published var memory: Int
    
    init(bid: String, goal: Int, value: Int, interest: Int, memory: Int) {
        self.bid = bid
        self.goal = goal
        self.value = value
        self.interest = interest
        self.memory = memory
    }
}
