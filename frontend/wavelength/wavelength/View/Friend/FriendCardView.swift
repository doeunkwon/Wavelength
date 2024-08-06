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
                    HStack(alignment: .center) {
                        Text(user.firstName)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(Color.wavelengthBlack)
                        Spacer()
                        Text(String(user.scorePercentage) + "%")
                            .font(.system(size: Fonts.body))
                            .foregroundColor(intToColor(value: user.scorePercentage))
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
    FriendCardView(user: User(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 100, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12))
}
