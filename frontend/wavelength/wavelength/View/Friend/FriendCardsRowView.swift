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
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}


#Preview {
    FriendCardsRowView(user1: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue), user2: User(uid: "2", firstName: "Andrea", lastName: "Fung", birthday: "06-22-2001", username: "andy pandy", email: "andrea@gmail.com", password: "Abc123", location: "Burnaby", interests: ["Travelling", "Swimming", "Volleyball"], emoji: "🪷", color: Color.wavelengthPink))
}
