//
//  FriendProfileView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct FriendProfileView: View {
    
    let user: User
    
    var body: some View {
        ZStack {
            HStack {
                ProfilePictureView(emoji: user.emoji, color: user.color, frameSize: FrameSizes.medium, emojiSize: Fonts.header)
                VStack(alignment: .leading) {
                    Text(user.firstName + " " + user.lastName)
                        .font(.system(size: Fonts.title))
                    Text(user.birthday)
                        .font(.system(size: Fonts.body))
                }
                .padding(.leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.wavelengthBackground)
    }
}

#Preview {
    FriendProfileView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "April 12, 2001", username: "billthemuffer", email: "doeun@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue))
}
