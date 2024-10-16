//
//  SliderCellView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

struct SliderCellView: View {
    
    let title: String
    let percentage: Int
    
    var body: some View {
        
        let color = intToColor(value: percentage)
        
        VStack (spacing: Padding.large) {
            HStack {
                Text(title)
                    .font(.system(size: Fonts.body))
                Spacer()
                Text(String(percentage))
                    .font(.system(size: Fonts.body))
                    .foregroundColor(color)
            }
            
            ProgressView(value: Double(percentage), total: 100)
                .tint(color)
        }
    }
}
