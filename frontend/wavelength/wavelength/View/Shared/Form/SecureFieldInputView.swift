//
//  SecureFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct SecureFieldInputView: View {
    var title: String = ""
    let placeholder: String
    let binding: Binding<String>

    var body: some View {
        VStack(alignment: .leading, spacing: Padding.medium) {
            
            if title.count > 0 {
                Text(title)
                    .font(.system(size: Fonts.body))
                    .foregroundStyle(.wavelengthDarkGrey)
            }
            
            SecureField(placeholder, text: binding)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthText)
        }
    }
}
