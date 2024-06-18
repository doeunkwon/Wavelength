//
//  FriendCardsRowView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-12.
//

import SwiftUI

struct FriendCardsRowView: View {
    let card1: FriendCardView
    let card2: FriendCardView? // Optional for the second card
    
    var body: some View {
        HStack {
            card1
            Spacer()
            if let card2 = card2 {
                card2
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 4)
    }
}


#Preview {
    FriendCardsRowView(card1: FriendCardView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue)), card2: FriendCardView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue)))
}
