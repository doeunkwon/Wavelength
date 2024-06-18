//
//  BasicFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct BasicFieldView: View {
    
    let field: String
    let userData: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(field)
                .font(.system(size: Fonts.subtitle))
                .padding(.bottom, 0.1)
            Text(userData)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthDarkGrey)
        }
    }
}

#Preview {
    BasicFieldView(field: Strings.profile.location, userData: "Port Moody")
}
