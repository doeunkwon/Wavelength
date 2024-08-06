//
//  FriendCardView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI


struct FriendCardView: View {
    
    let friend: Friend
    
    var body: some View {
        NavigationLink(destination: FriendProfileView(friend: friend)) {
            ZStack {
                VStack(alignment: .leading) {
                    
                    ProfilePictureView(emoji: friend.emoji, color: friend.color, frameSize: FrameSizes.large, emojiSize: Fonts.icon)
                    
                    // Name and username below the emoji
                    HStack(alignment: .center) {
                        Text(friend.firstName)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(Color.wavelengthBlack)
                        Spacer()
                        Text(String(friend.scorePercentage) + "%")
                            .font(.system(size: Fonts.body))
                            .foregroundColor(intToColor(value: friend.scorePercentage))
                    }
                }
                .padding(Padding.medium)
            }
            .background(Color.wavelengthOffWhite)
            .cornerRadius(10)
            .frame(width: FrameSizes.large + (Padding.medium * 2))
        }
    }
}

#Preview {
    FriendCardView(friend: Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 100, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12))
}
