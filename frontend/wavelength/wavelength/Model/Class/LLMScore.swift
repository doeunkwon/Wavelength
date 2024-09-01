//
//  LLMScore.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI

class LLMScore {
    
    let goal: Int
    let value: Int
    let interest: Int
    let memory: Int
    let analysis: String
    
    init(goal: Int, value: Int, interest: Int, memory: Int, analysis: String) {
        self.goal = goal
        self.value = value
        self.interest = interest
        self.memory = memory
        self.analysis = analysis
    }
}
