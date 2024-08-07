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
            .padding(.horizontal, Padding.medium + 3)
            .padding(.vertical, Padding.medium)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: CornerRadius.max)
                    .stroke(color, lineWidth: Border.medium))
            .background(.wavelengthOffWhite)
            .cornerRadius(CornerRadius.max)
    }
}

#Preview {
    InterestTagView(interest: "Muay Thai", color: Color.wavelengthViolet)
}
