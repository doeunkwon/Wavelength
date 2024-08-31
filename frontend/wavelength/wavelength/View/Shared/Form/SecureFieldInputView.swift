//
//  SecureFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct SecureFieldInputView: View {
    let placeholder: String
    let binding: Binding<String>

    var body: some View {
        VStack(alignment: .leading, spacing: Padding.medium) {
            SecureField(placeholder, text: binding)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthText)
        }
    }
}
