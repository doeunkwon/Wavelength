//
//  BasicFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct BasicFieldView: View {
    
    let field: String
    let friendData: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(field)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthDarkGrey)
                .padding(.bottom, Padding.xxsmall)
            Text(friendData)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthBlack)
        }
    }
}

#Preview {
    BasicFieldView(field: Strings.profile.goals, friendData: "Port Moody")
}
