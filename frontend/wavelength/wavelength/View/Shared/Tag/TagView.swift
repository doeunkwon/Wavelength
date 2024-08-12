//
//  TagView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct TagView: View {
    
    @EnvironmentObject var valueTagManager: ValueTagManager
    @EnvironmentObject var interestTagManager: InterestTagManager
    
    let text: String
    let color: Color
    let editable: Bool
    
    var body: some View {
        HStack {
            Text(text)
            if editable {
                Button {
                    valueTagManager.removeValueTag(tag: text)
                } label: {
                    Image(systemName: Strings.icons.xmark)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthGrey)
                        .padding(.leading, Padding.xsmall)
                }
            }
        }
            .font(.system(size: Fonts.body))
            .padding(Padding.medium)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: CornerRadius.max)
                    .stroke(color, lineWidth: Border.medium))
            .background(.wavelengthOffWhite)
            .cornerRadius(CornerRadius.max)
    }
}

#Preview {
    TagView(text: "Muay Thai", color: Color.wavelengthViolet, editable: true)
}
