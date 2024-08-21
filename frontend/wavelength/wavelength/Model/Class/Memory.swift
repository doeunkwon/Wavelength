//
//  Memory.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

class Memory: ObservableObject, Hashable, Equatable {
    
    @Published var mid: String
    @Published var date: Date
    @Published var title: String
    @Published var content: String
    @Published var tokens: Int
    
    static func == (lhs: Memory, rhs: Memory) -> Bool {
      return lhs.mid == rhs.mid && lhs.date == rhs.date && lhs.title == rhs.title
             && lhs.content == rhs.content && lhs.tokens == rhs.tokens
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(mid)
        }
    
    init(mid: String, date: Date, title: String, content: String, tokens: Int) {
        self.mid = mid
        self.date = date
        self.title = title
        self.content = content
        self.tokens = tokens
    }
}
