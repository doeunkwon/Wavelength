//
//  EmptyStateView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-18.
//

import SwiftUI

struct EmptyStateView: View {
    
    let text: String
    let icon: String
    
    var body: some View {
        VStack (spacing: Padding.medium) {
            
            Image(systemName: icon)
                .font(.system(size: Fonts.header))
            Text(text)
                .font(.system(size: Fonts.subtitle))
            
        }
        .foregroundColor(.wavelengthGrey)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.wavelengthBackground)
    }
}

#Preview {
    EmptyStateView(text: Strings.friend.addAFriend, icon: Strings.icons.person2)
}
