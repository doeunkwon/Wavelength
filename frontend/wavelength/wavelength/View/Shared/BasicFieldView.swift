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
            Text(friendData)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthText)
        }
    }
}

#Preview {
    BasicFieldView(field: Strings.general.goals, friendData: "Port Moody")
}
