//
//  FriendCardView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI

struct FriendCardView: View {
    let firstName: String
    let username: String
    let emoji: String
    let color: Color
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // Emoji in a colored square
                ZStack {
                    color.frame(width: .infinity, height: 150)
                    Text(emoji)
                        .font(.system(size: Fonts.icon))
                }
                .cornerRadius(8)
                
                // Name and username below the emoji
                VStack(alignment: .leading) {
                    Text(firstName)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(Color.wavelengthBlack)
                    Text(username)
                        .font(.system(size: Fonts.body2))
                        .foregroundColor(Color.wavelengthDarkGrey)
                }
            }
            .padding(10)
        }
        .background(Color.wavelengthOffWhite)
    }
}

#Preview {
    FriendCardView(firstName: "Doeun", username: "billthemuffer", emoji: "🌎", color: Color.wavelengthBlue)
}
