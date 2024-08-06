//
//  InterestTagView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct InterestTagView: View {
    
    let interest: String
    let color: Color
    
    var body: some View {
        Text(interest)
            .font(.system(size: Fonts.body))
            .padding(Padding.medium)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 100)
                    .stroke(color, lineWidth: 2))
    }
}

#Preview {
    InterestTagView(interest: "Muay Thai", color: Color.wavelengthViolet)
}
