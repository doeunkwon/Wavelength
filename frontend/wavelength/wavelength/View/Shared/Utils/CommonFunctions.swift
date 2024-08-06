//
//  CommonFunctions.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import Foundation
import SwiftUI

func intToColor(value: Int) -> Color {
    let maxVal = 100.0
    let red = CGFloat(maxVal - Double(value)) / maxVal
    let green = CGFloat(Double(value)) / maxVal
    return Color(red: red, green: green, blue: 0.0, opacity: 1.0)
}
