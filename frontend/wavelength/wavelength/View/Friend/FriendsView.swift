//
//  FriendsView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct FriendsView: View {
    
    @State private var showNewFriendViewModal = false
    
    private var friends: [Friend]
    
    init(friends: [Friend]) {
        let sortedFriends = friends.sorted { $0.scorePercentage > $1.scorePercentage }
        self.friends = sortedFriends
    }
    
    var body: some View {
        
            ZStack(alignment: .bottom) {
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        DashboardView(scorePercentage: 75, tokenCount: 74, memoryCount: 210, data: {
                            let sampleDate = Date().startOfDay.adding(.day, value: -10)!
                            var temp = [LineChartData]()
                            
                            for i in 0..<20 {
                                let value = Double.random(in: 5...20)
                                temp.append(
                                    LineChartData(
                                        date: sampleDate.adding(.day, value: i)!,
                                        value: value
                                    )
                                )
                            }
                            
                            return temp
                        }())
                        .padding(.top, Padding.large)
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
                            .accentColor(.wavelengthGrey)
                    }
                    .padding(.vertical, Padding.xlarge)
                    .sheet(isPresented: $showNewFriendViewModal) {
                        NewFriendView()
                    }
                }
            }
            .background(Color.wavelengthBackground)
    }
}

#Preview {
    FriendsView(friends: [
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12, values: ["Discipline", "Integrity", "Growth", "Positivity"]),
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12, values: ["Discipline", "Integrity", "Growth", "Positivity"]),
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Doeun", lastName: "Kwon", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 50, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12, values: ["Discipline", "Integrity", "Growth", "Positivity"])
    ])
}
