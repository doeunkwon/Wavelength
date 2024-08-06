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
        NavigationStack {
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
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.title))
                            .accentColor(.wavelengthPurple)
                    }
                    .padding(.vertical, Padding.xlarge)
                    .sheet(isPresented: $showNewFriendViewModal) {
                        NewFriendView()
                    }
                }
            }
        }
        .accentColor(.blue)
    }
}

#Preview {
    FriendsView(friends: [
        User(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12)
    ])
}
