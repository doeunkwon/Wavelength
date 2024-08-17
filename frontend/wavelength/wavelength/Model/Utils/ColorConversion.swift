//
//  ColorConversion.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-16.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            let r, g, b, a: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                r = (hexNumber & 0xF00) >> 8
                g = (hexNumber & 0x0F0) >> 4
                b = hexNumber & 0x00F
                a = 255
            case 6: // RGB (24-bit)
                r = (hexNumber & 0xFF0000) >> 16
                g = (hexNumber & 0x00FF00) >> 8
                b = hexNumber & 0x0000FF
                a = 255
            case 8: // RGBA (32-bit)
                r = (hexNumber & 0xFF000000) >> 24
                g = (hexNumber & 0x00FF0000) >> 16
                b = (hexNumber & 0x0000FF00) >> 8
                a = hexNumber & 0x000000FF
            default:
                print("Invalid hex string: \(hex)")
                r = 0
                g = 0
                b = 0
                a = 255
            }
            
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, opacity: CGFloat(a) / 255)
        } else {
            self = .clear
        }
    }
    
    var hexString: String {
        let components = self.components()
        let r = components.red * 255
        let g = components.green * 255
        let b = components.blue * 255
        let a = components.alpha * 255
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }

    private func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        guard let cgColor = self.cgColor else {
            // Handle the case where cgColor is nil
            return (0, 0, 0, 0) // Or return default values
        }

        let components = cgColor.components!
        return (red: CGFloat(components[0]), green: CGFloat(components[1]), blue: CGFloat(components[2]), alpha: CGFloat(components[3]))
    }
}
