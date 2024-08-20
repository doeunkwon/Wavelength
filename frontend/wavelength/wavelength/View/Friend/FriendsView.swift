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
    
    private var friends: [Friend]
    private var scoreChartData: [ScoreData]
    
    init(friends: [Friend], scoreChartData: [ScoreData]) {
        let sortedFriends = friends.sorted { $0.scorePercentage > $1.scorePercentage }
        self.friends = sortedFriends
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
                                ForEach(Array(stride(from: friends.startIndex, to: friends.endIndex, by: 2)), id: \.self) { index in
                                    let friend1 = friends[index]
                                    let friend2 = index + 1 < friends.endIndex ? friends[index + 1] : nil
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
                        NewFriendView()
                            .interactiveDismissDisabled()
                    }
                }
                .padding(.vertical, Padding.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.wavelengthBackground)
    }
}

#Preview {
    FriendsView(friends: Mock.friends, scoreChartData: Mock.scoreChartData)
        .environmentObject(Mock.user)
}
