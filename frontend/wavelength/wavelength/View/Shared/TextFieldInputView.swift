//
//  TextFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TextFieldInputView: View {
    let title: String
    let placeholder: String
    let binding: Binding<String>
    let isMultiLine: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Padding.medium) {
            if isMultiLine {
                TextField(placeholder, text: binding, axis: .vertical)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthText)
            } else {
                TextField(placeholder, text: binding)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthText)
            }
        }
    }
}
