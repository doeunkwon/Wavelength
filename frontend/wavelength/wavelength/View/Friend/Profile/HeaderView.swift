//
//  HeaderView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct HeaderView: View {
    
    let emoji: String
    let color: Color
    let firstName: String
    let lastName: String
    let birthday: String
    
    var body: some View {
        HStack {
            ProfilePictureView(emoji: emoji, color: color, frameSize: FrameSizes.medium, emojiSize: Fonts.header)
            VStack(alignment: .leading) {
                Text(firstName + " " + lastName)
                    .font(.system(size: Fonts.title))
                Text(birthday)
                    .font(.system(size: Fonts.body))
                    .foregroundStyle(.wavelengthDarkGrey)
            }
            .padding(.leading, 12)
        }
    }
}

#Preview {
    HeaderView(emoji: "🌎", color: Color.wavelengthBlue, firstName: "Doeun", lastName: "Kwon", birthday: "April 12, 2001")
}
