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
    @State private var scrollOffset: CGFloat = 0
    
    @Binding private var selectedTab: Int
    
    private let scoreChartData: [ScoreData]
    
    init(scoreChartData: [ScoreData], selectedTab: Binding<Int>) {
        self.scoreChartData = scoreChartData
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        
            ZStack(alignment: .top) {
                
                GeometryReader { geometry in
                    
                    /// No friends
                    if friendsManager.friends.count == 0 {
                        
                        EmptyStateView(text: Strings.Friends.add, icon: Strings.Icons.personTwo)
                        
                    } else {
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .center, spacing: 0) {
                                
                                DashboardView(
                                    firstEntry: (Strings.Score.overall, "\(user.scorePercentage)%"),
                                    firstEntryColor: intToColor(value: user.scorePercentage),
                                    secondEntry: (Strings.Dashboard.tokens, (user.tokenCount > 0 ? "+" : "") + String(user.tokenCount)),
                                    secondEntryColor: .wavelengthTokenOrange,
                                    thirdEntry: (Strings.Dashboard.memories, String(user.memoryCount)),
                                    thirdEntryColor: .wavelengthText,
                                    lineGraphColor: intToColor(value: user.scorePercentage),
                                    data: scoreChartData)
                                .padding(.horizontal, Padding.large)
                                .padding(.top, Padding.large + Frame.customNavbarHeight)
                                
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
                            .background(GeometryReader { innerGeometry in
                                Color.clear
                                    .onAppear {
                                        scrollOffset = innerGeometry.frame(in: .global).minY
                                    }
                                    .onChange(of: innerGeometry.frame(in: .global).minY) {
                                        scrollOffset = innerGeometry.frame(in: .global).minY
                                    }
                            })
                        }
                        
                    }
                    HStack (alignment: .center) {
                        
                        TabButtonView(selectedTab: $selectedTab, destinationTab: 0, icon: Strings.Icons.gearshape, color: user.color)
                        
                        Spacer()
                        
                        Text(Strings.Friends.yourCircle)
                            .font(.system(size: Fonts.subtitle, weight: .semibold))
                            .foregroundStyle(.wavelengthText)
                        
                        Spacer()
                        
                        AddButtonView(showModal: $showNewFriendViewModal, size: Frame.xsmall, fontSize: Fonts.subtitle, color: user.color) {
                            NewFriendView(friendsManager: friendsManager, showNewFriendViewModal: $showNewFriendViewModal)
                                .interactiveDismissDisabled()
                        }
                    }
                    .padding(.horizontal, Padding.large)
                    .padding(.bottom, Padding.medium)
                    .frame(height: Frame.customNavbarHeight)
                    .background(.wavelengthBackground)
                    .shadow(
                        color: ((scrollOffset < Frame.customNavbarHeight) && (friendsManager.friends.count > 0)) ? ShadowStyle.low.color : .clear,
                        radius: ShadowStyle.low.radius,
                        x: ShadowStyle.low.x,
                        y: ShadowStyle.low.y)
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.wavelengthBackground)
    }
}

#Preview {
    
    @State var selectedTab = 1
    let friendsManager = FriendsManager(friends: [])
    
    return FriendsView(scoreChartData: Mock.scoreChartData, selectedTab: $selectedTab)
        .environmentObject(Mock.user)
        .environmentObject(friendsManager)
}
