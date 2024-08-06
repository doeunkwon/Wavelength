//
//  FriendProfileView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct FriendProfileView: View {
    
    let friend: Friend
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HeaderView(emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, tokenCount: friend.tokenCount)
                    .padding(.bottom, Padding.large)
                
                Divider()
                
                BasicFieldView(field: Strings.profile.goals, friendData: friend.goals)
                    .padding(.vertical, Padding.large)
                
                Divider()
                
                InterestFieldView(interests: friend.interests, tagColor: friend.color)
                    .padding(.vertical, Padding.large)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.wavelengthBackground)
    }
}

#Preview {
    FriendProfileView(friend: Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12))
}
