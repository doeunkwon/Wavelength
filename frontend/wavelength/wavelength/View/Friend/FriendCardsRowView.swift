//
//  FriendCardsRowView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI

struct FriendCardsRowView: View {
    let user1: User
    let user2: User? // Optional for the second user
    
    var body: some View {
        HStack {
            FriendCardView(user: user1)
            Spacer()
            if let user2 = user2 {
                FriendCardView(user: user2)
            }
        }
        .padding(.horizontal, Padding.large)
        .padding(.vertical, Padding.small)
    }
}


#Preview {
    FriendCardsRowView(user1: User(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12), user2: User(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12))
}
