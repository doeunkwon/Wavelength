//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var showNewFriendViewModal = false
    
    let friends: [User]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    ForEach(Array(stride(from: friends.startIndex, to: friends.endIndex, by: 2)), id: \.self) { index in
                        let user1 = friends[index]
                        let user2 = index + 1 < friends.endIndex ? friends[index + 1] : nil
                        FriendCardsRowView(user1: user1, user2: user2)
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
    FriendsView(friends: [
        User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "04-12-2001", username: "billthemuffer", email: "doeun@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue),
        User(uid: "2", firstName: "Andrea", lastName: "Fung", birthday: "06-22-2001", username: "andy pandy", email: "andrea@gmail.com", password: "Abc123", location: "Burnaby", interests: ["Travelling", "Swimming", "Volleyball"], emoji: "🪷", color: Color.wavelengthPink),
        User(uid: "3", firstName: "Austin", lastName: "Lee", birthday: "03-15-2001", username: "leezy", email: "austin@gmail.com", password: "Abc123", location: "Coquitlam", interests: ["Camping", "Fishing", "Climbing"], emoji: "🌲", color: Color.wavelengthGreen)
    ])
}
