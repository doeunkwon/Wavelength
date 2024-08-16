//
//  BasicFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct BasicFieldView: View {
    
    var title: String = ""
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Padding.medium) {
            if title.count > 0 {
                Text(title)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthDarkGrey)
            }
            Text(content)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthText)
        }
    }
}

#Preview {
    BasicFieldView(content: "Port Moody")
}
