//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 1
    
    let friends = [
        Friend(emoji: "🌞", color: Color.wavelengthYellow, uid: "1", firstName: "Austin", lastName: "Lee", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 90, scoreAnalysis: "Amazing friendship!", tokenCount: 23, memoryCount: 12),
        Friend(emoji: "🦄", color: Color.wavelengthViolet, uid: "1", firstName: "Patrick", lastName: "Ruszyzck", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 84, scoreAnalysis: "Amazing friendship!", tokenCount: 15, memoryCount: 12),
        Friend(emoji: "🌎", color: Color.wavelengthBlue, uid: "1", firstName: "Carson", lastName: "Guillemet", goals: "To just do it.", interests: ["Programming", "Travelling", "Boxing"], scorePercentage: 79, scoreAnalysis: "Amazing friendship!", tokenCount: -7, memoryCount: 12)
    ]
    
    var body: some View {
        FriendsView(friends: friends)
//        TabView(selection: $selectedTab) {
//            SettingsView()
//                .tabItem { Image(systemName: Strings.icons.gearshape) }
//                .tag(0)
//            FriendsView(friends: friends)
//                .tabItem { Image(systemName: Strings.icons.squareGrid2by2) }
//                .tag(1)
//        }
//        .accentColor(Color.wavelengthPurple)
    }
}

#Preview {
    ContentView()
}
