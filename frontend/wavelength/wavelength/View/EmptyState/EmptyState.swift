//
//  EmptyState.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import SwiftUI

struct EmptyState: View {
    
    let text: String
    let icon: String
    
    var body: some View {
        VStack (alignment: .center, spacing: Padding.medium) {
            Image(systemName: icon)
                .font(.system(size: Fonts.header))
            Text(text)
                .font(.system(size: Fonts.subtitle))
        }
        .foregroundStyle(.wavelengthGrey)
    }
}

#Preview {
    EmptyState(text: Strings.friend.addAFriend, icon: Strings.icons.person2)
}
