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
        .frame(maxWidth: card2 == nil ? UIScreen.main.bounds.width / 2 - 20 : .infinity)
        .cornerRadius(10)
      if let card2 = card2 {
        card2
          .cornerRadius(10)
      }
    }
  }
}


#Preview {
    FriendCardsRowView(card1: FriendCardView(firstName: "Doeun", username: "billthemuffer", emoji: "🌎", color: Color.wavelengthBlue), card2: nil)
}
