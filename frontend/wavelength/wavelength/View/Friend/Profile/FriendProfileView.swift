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
                    .padding(.bottom, Padding.medium)
                
                HStack(alignment: .center, spacing: Padding.large) {
                    ButtonView(title: String(friend.scorePercentage) + "% match", color: intToColor(value: friend.scorePercentage), action: {print("Score button tapped")})
                    ButtonView(title: String(friend.memoryCount) + " memories", color: .wavelengthBlack, action: {print("Memory button tapped")})
                }
                .padding(.bottom, Padding.large)
                .shadow(
                    color: ShadowStyle.subtle.color,
                    radius: ShadowStyle.subtle.radius,
                    x: ShadowStyle.subtle.x,
                    y: ShadowStyle.subtle.y)
                
                DividerLine()
                
                BasicFieldView(field: Strings.profile.goals, friendData: friend.goals)
                    .padding(.vertical, Padding.large)
                
                DividerLine()
                
                ValueFieldView(values: ["Discipline": 89, "Integrity": 76, "Growth": 81])
                    .padding(.vertical, Padding.large)
                
                DividerLine()
                
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
