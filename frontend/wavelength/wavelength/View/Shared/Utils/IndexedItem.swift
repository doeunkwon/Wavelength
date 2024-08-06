//
//  IndexedItem.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

struct IndexedItem<T>: Identifiable {
    let id = UUID()
    let index: Int
    let value: T
}
