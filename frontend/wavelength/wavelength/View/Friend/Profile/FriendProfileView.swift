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
        ScrollView {
            VStack(alignment: .leading) {
                
                HeaderView(emoji: user.emoji, color: user.color, firstName: user.firstName, lastName: user.lastName, tokenCount: user.tokenCount)
                    .padding(.bottom, Padding.large)
                
                Divider()
                
                BasicFieldView(field: Strings.profile.goals, userData: user.goals)
                    .padding(.vertical, Padding.large)
                
                Divider()
                
                InterestFieldView(interests: user.interests, tagColor: user.color)
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
    FriendProfileView(user: User(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12))
}
