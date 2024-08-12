//
//  TagsFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct TagsFieldView: View {
    
    let title: String
    let items: [String]
    let tagColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthDarkGrey)
            TagsView(items: items, color: tagColor, editable: false)
        }
    }
}

#Preview {
    TagsFieldView(title: Strings.general.interests, items: ["Programming", "Travelling", "Boxing", "EDM", "Reading"], tagColor: .wavelengthBlue)
}
