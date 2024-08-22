//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    
    @EnvironmentObject var user: User
    
    @State private var showNewFriendViewModal = false
    
    @Binding private var friends: [Friend]
    private let scoreChartData: [ScoreData]
    
    init(friends: Binding<[Friend]>, scoreChartData: [ScoreData]) {
        self._friends = friends
        self.scoreChartData = scoreChartData
    }
    
    var body: some View {
        
            ZStack(alignment: .bottom) {
                    
                /// No friends
                if friends.count == 0 {
                    
                    VStack {
                        Spacer()
                        EmptyStateView(text: Strings.friend.addAFriend, icon: Strings.icons.person2)
                        Spacer()
                    }
                    
                } else {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                            Text(Strings.general.yourCircle)
                                .font(.system(size: Fonts.title, weight: .semibold))
                                .foregroundStyle(.wavelengthText)
                                .padding(.horizontal, Padding.large)
                                .padding(.bottom, Padding.large)
                            
                            
                            DashboardView(scorePercentage: user.scorePercentage, tokenCount: user.tokenCount, memoryCount: user.memoryCount, data: scoreChartData)
                            .padding(.horizontal, Padding.large)
                            
                            LazyVStack(alignment: .leading, spacing: Padding.large) {
                                let sortedFriends = friends.sorted { $0.scorePercentage > $1.scorePercentage }
                                ForEach(Array(stride(from: sortedFriends.startIndex, to: sortedFriends.endIndex, by: 2)), id: \.self) { index in
                                    let friend1 = sortedFriends[index]
                                    let friend2 = index + 1 < sortedFriends.endIndex ? sortedFriends[index + 1] : nil
                                    FriendCardsRowView(friend1: friend1, friend2: friend2)
                                }
                            }
                            .shadow(
                                color: ShadowStyle.standard.color,
                                radius: ShadowStyle.standard.radius,
                                x: ShadowStyle.standard.x,
                                y: ShadowStyle.standard.y)
                            .padding(Padding.large)
                                
                        }
                    }
                    
                }
                
                ZStack {
                    Circle()
                        .frame(width: 45)
                        .foregroundColor(.wavelengthOffWhite)
                        .shadow(
                            color: ShadowStyle.subtle.color,
                            radius: ShadowStyle.subtle.radius,
                            x: ShadowStyle.subtle.x,
                            y: ShadowStyle.subtle.y)
                    Button {
                        print("Add new friend!")
                        showNewFriendViewModal.toggle()
                    } label: {
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.title))
                            .accentColor(.wavelengthGrey)
                    }
                    .sheet(isPresented: $showNewFriendViewModal) {
                        NewFriendView(friends: $friends)
                            .interactiveDismissDisabled()
                    }
                }
                .padding(.vertical, Padding.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.wavelengthBackground)
    }
}

