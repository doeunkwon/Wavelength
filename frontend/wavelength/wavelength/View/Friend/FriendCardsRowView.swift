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
    FriendCardsRowView(card1: FriendCardView(firstName: "Doeun", username: "billthemuffer", emoji: "🌎", color: Color.wavelengthBlue), card2: FriendCardView(firstName: "Andrea", username: "andrea.funggg", emoji: "🪷", color: Color.wavelengthPink))
}
