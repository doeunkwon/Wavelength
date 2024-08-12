//
//  TagsFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsFieldInputView: View {
    let title: String
    let binding: Binding<[String]>
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Padding.large) {
            Text(title)
                .font(.system(size: Fonts.body))
            
            // Keep in mind that .wrappedValue just copies the underlying VALUE of the binding, NOT the reference.
            TagsView(items: binding.wrappedValue, color: color, editable: true)
        }
    }
}
