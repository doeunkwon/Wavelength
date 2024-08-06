//
//  FriendCardsRowView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI

struct FriendCardsRowView: View {
    let friend1: Friend
    let friend2: Friend? // Optional for the second friend
    
    var body: some View {
        HStack (spacing: Padding.large) {
            FriendCardView(friend: friend1)
            if let friend2 = friend2 {
                FriendCardView(friend: friend2)
            } else {
                Spacer()
            }
        }
        .padding(.horizontal, Padding.large)
        .padding(.vertical, Padding.medium / 2)
    }
}


#Preview {
    FriendCardsRowView(friend1: Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12), friend2: Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12))
}
