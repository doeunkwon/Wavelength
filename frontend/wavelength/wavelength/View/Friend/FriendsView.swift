//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var showNewFriendViewModal = false
    
    let friendCards: [FriendCardView]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(stride(from: friendCards.startIndex, to: friendCards.endIndex, by: 2)), id: \.self) { index in
                        let card1 = friendCards[index]
                        let card2 = index + 1 < friendCards.endIndex ? friendCards[index + 1] : nil
                        FriendCardsRowView(card1: card1, card2: card2)
                    }
                }
            }
            .background(Color.wavelengthBackground)
            .shadow(color: Color(white: 0.0, opacity: 0.06), radius: 10, x: 0, y: 4)
            
            ZStack {
                Circle()
                    .frame(width: 45)
                    .foregroundColor(.wavelengthOffWhite)
                    .shadow(color: Color(white: 0.0, opacity: 0.06), radius: 8, x: 0, y: 4)
                Button {
                    print("Add new friend!")
                    showNewFriendViewModal.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: Fonts.title))
                        .accentColor(.wavelengthPurple)
                }
                .padding(.vertical, 30)
                .sheet(isPresented: $showNewFriendViewModal) {
                    NewFriendView()
                }
            }
        }
    }
}

#Preview {
    FriendsView(friendCards: [
        FriendCardView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue)),
        FriendCardView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue)),
        FriendCardView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "bkwon38@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue)),
        // Add more FriendCardViews here
    ])
}
