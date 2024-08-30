//
//  FriendCardView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI


struct FriendCardView: View {
    
    @EnvironmentObject private var user: User
    @EnvironmentObject var friendsManager: FriendsManager
    
    @ObservedObject var friend: Friend
    
    var body: some View {
        
        /// REASON FOR THE SUPER COMPLEX frameSize:
        /// KEEP IN MIND THAT UISCREEN SIZES ARE FIXED.
        /// THIS IS WHAT MAKES THE SIZING MORE COMPLEX.
        /// We could've used GeometryReader but that comes with its own set of issues.
        /// Here's the explanation:
        /// Each FriendCardView needs to be of half the width of the screen.
        /// ^ explains the UIScreen.main.bounds.width / 2
        /// But furthermore, because we have a Padding.large padding on the edges of the parent screen (FriendCardsRowView), we need to leave 'Padding.large' amount more room.
        /// Which means we should subtract Padding.large from our 'UIScreen.main.bounds.width / 2'.
        /// But again, because we have a Padding.large padding between each FriendCardView, we need to leave 'Padding.large / 2' amount more room FOR EACH FriendCardView.
        /// Which means we should subtract 'Padding.large / 2' from our 'UIScreen.main.bounds.width / 2 - Padding.large'.
        /// ^ explains the UIScreen.main.bounds.width / 2 - (Padding.large + (Padding.large / 2))
        
        NavigationLink(destination: FriendProfileView(user: user, friend: friend, friendsCount: friendsManager.friends.count)) {
                ZStack {
                    VStack(alignment: .leading) {
                        ProfilePictureView(emoji: friend.emoji, color: friend.color, frameSize: Frame.friendCard, emojiSize: Fonts.icon)
                        // The (Padding.medium * 2) is the padding in between the profile picture and the edges of the card
                        
                        // Name and username below the emoji
                        HStack(alignment: .center) {
                            Text(friend.firstName)
                                .font(.system(size: Fonts.body))
                                .foregroundColor(Color.wavelengthText)
                            Spacer()
                            Text(String(friend.scorePercentage) + "%")
                                .font(.system(size: Fonts.body))
                                .foregroundColor(intToColor(value: friend.scorePercentage))
                        }
                    }
                    .padding(Padding.medium)
                }
                .background(Color.wavelengthOffWhite)
                .cornerRadius(CornerRadius.medium)
                .frame(width: Frame.friendCardBackground)
        }
    }
}
