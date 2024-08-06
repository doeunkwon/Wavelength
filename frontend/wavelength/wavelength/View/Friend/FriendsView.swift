//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var showNewFriendViewModal = false
    
    let friends: [Friend]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        ForEach(Array(stride(from: friends.startIndex, to: friends.endIndex, by: 2)), id: \.self) { index in
                            let friend1 = friends[index]
                            let friend2 = index + 1 < friends.endIndex ? friends[index + 1] : nil
                            FriendCardsRowView(friend1: friend1, friend2: friend2)
                        }
                    }
                }
                .background(Color.wavelengthBackground)
                .shadow(
                    color: ShadowStyle.standard.color,
                    radius: ShadowStyle.standard.radius,
                    x: ShadowStyle.standard.x,
                    y: ShadowStyle.standard.y)
                
                ZStack {
                    Circle()
                        .frame(width: 45)
                        .foregroundColor(.wavelengthOffWhite)
                        .shadow(
                            color: ShadowStyle.standard.color,
                            radius: ShadowStyle.standard.radius,
                            x: ShadowStyle.standard.x,
                            y: ShadowStyle.standard.y)
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
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12),
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12),
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12)
    ])
}
