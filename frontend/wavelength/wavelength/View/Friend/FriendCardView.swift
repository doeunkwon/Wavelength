//
//  FriendCardView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI

struct FriendCardView: View {
    
    let user: User
    
    var body: some View {
        NavigationLink(destination: FriendProfileView(user: user)) {
            ZStack {
                VStack(alignment: .leading) {
                    
                    ProfilePictureView(emoji: user.emoji, color: user.color, frameSize: FrameSizes.large, emojiSize: Fonts.icon)
                    
                    // Name and username below the emoji
                    VStack(alignment: .leading) {
                        Text(user.firstName)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(Color.wavelengthBlack)
                        Text(user.username)
                            .font(.system(size: Fonts.body2))
                            .foregroundColor(Color.wavelengthDarkGrey)
                    }
                }
                .padding(10)
            }
            .background(Color.wavelengthOffWhite)
            .cornerRadius(10)
        }
    }
}

#Preview {
    FriendCardView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue))
}
