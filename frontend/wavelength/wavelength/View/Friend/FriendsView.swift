//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    let friendCards: [FriendCardView] // Array of FriendCardViews
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                ForEach(Array(stride(from: friendCards.startIndex, to: friendCards.endIndex, by: 2)), id: \.self) { index in
                    let card1 = friendCards[index]
                    let card2 = index + 1 < friendCards.endIndex ? friendCards[index + 1] : nil
                    FriendCardsRowView(card1: card1, card2: card2)
                }
            }
            .padding(.horizontal)
        }
        .background(Color.background)
        .shadow(color: Color(white: 0.0, opacity: 0.06), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    FriendsView(friendCards: [
        FriendCardView(firstName: "Doeun", username: "billthemuffer", emoji: "🌎", color: Color.wavelengthBlue),
        FriendCardView(firstName: "Andrea", username: "andrea.funggg", emoji: "🪷", color: Color.wavelengthPink),
        FriendCardView(firstName: "Austin", username: "austtnl", emoji: "🌲", color: Color.wavelengthGreen),
        // Add more FriendCardViews here
    ])
}
