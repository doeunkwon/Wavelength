//
//  CommonFunctions.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import Foundation
import SwiftUI

func intToColor(value: Int) -> Color {
    let greenValue = CGFloat(value) / 100.0
    return Color(hue: greenValue / 3, saturation: 1.0, brightness: 0.8, opacity: 1.0)
}
