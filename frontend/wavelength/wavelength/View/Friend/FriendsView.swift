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
    
    @Binding private var selectedTab: Int
    
    private let scoreChartData: [ScoreData]
    
    init(scoreChartData: [ScoreData], selectedTab: Binding<Int>) {
        self.scoreChartData = scoreChartData
        self._selectedTab = selectedTab
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
                        VStack(alignment: .center, spacing: 0) {
                            
                            HStack (alignment: .center) {
                                
                                SettingsButtonView(selectedTab: $selectedTab, color: user.color)
                                
                                Spacer()
                                
                                Text(Strings.general.yourCircle)
                                    .font(.system(size: Fonts.subtitle, weight: .semibold))
                                    .foregroundStyle(.wavelengthText)
                                
                                Spacer()
                                
                                AddButtonView(showModal: $showNewFriendViewModal, size: Frame.xsmall, fontSize: Fonts.subtitle, color: user.color) {
                                    NewFriendView(friendsManager: friendsManager, showNewFriendViewModal: $showNewFriendViewModal)
                                        .interactiveDismissDisabled()
                                }
                            }
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
                                color: ShadowStyle.low.color,
                                radius: ShadowStyle.low.radius,
                                x: ShadowStyle.low.x,
                                y: ShadowStyle.low.y)
                            .padding(Padding.large)
                                
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.wavelengthBackground)
    }
}
