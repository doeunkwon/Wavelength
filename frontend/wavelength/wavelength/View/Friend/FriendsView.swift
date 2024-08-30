//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    
    @EnvironmentObject var user: User
    @EnvironmentObject var friendsManager: FriendsManager
    
    @State private var showNewFriendViewModal = false
    
    private let scoreChartData: [ScoreData]
    
    init(scoreChartData: [ScoreData]) {
        self.scoreChartData = scoreChartData
    }
    
    var body: some View {
        
            ZStack(alignment: .bottom) {
                    
                /// No friends
                if friendsManager.friends.count == 0 {
                    
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
                            
                            
                            DashboardView(
                                firstEntry: (Strings.dashboard.overall, "\(user.scorePercentage)%"),
                                firstEntryColor: intToColor(value: user.scorePercentage),
                                secondEntry: (Strings.dashboard.tokens, (user.tokenCount > 0 ? "+" : "") + String(user.tokenCount)),
                                secondEntryColor: .wavelengthTokenOrange,
                                thirdEntry: (Strings.dashboard.memories, String(user.memoryCount)),
                                thirdEntryColor: .wavelengthText,
                                lineGraphColor: intToColor(value: user.scorePercentage),
                                data: scoreChartData)
                            .padding(.horizontal, Padding.large)
                            
                            LazyVStack(alignment: .leading, spacing: Padding.large) {
                                let sortedFriends = friendsManager.friends.sorted { $0.scorePercentage > $1.scorePercentage }
                                ForEach(Array(stride(from: sortedFriends.startIndex, to: sortedFriends.endIndex, by: 2)), id: \.self) { index in
                                    let friend1 = sortedFriends[index]
                                    let friend2 = index + 1 < sortedFriends.endIndex ? sortedFriends[index + 1] : nil
                                    FriendCardsRowView(friend1: friend1, friend2: friend2)
                                }
                                .environmentObject(friendsManager)
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
                        NewFriendView(friendsManager: friendsManager)
                            .interactiveDismissDisabled()
                    }
                }
                .padding(.vertical, Padding.large)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.wavelengthBackground)
    }
}
