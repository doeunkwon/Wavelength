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
        VStack (spacing: Padding.large) {
            HStack {
                Text(title)
                    .font(.system(size: Fonts.body))
                Spacer()
                Text(String(percentage) + "%")
                    .font(.system(size: Fonts.body))
                    .foregroundColor(intToColor(value: percentage))
            }
            
            ProgressView(value: Double(percentage), total: 100)
                .tint(intToColor(value: percentage))
        }
    }
}

#Preview {
    SliderCellView(title: "Growth", percentage: 80)
}
