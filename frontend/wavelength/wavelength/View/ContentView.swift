//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem { Image(systemName: "gearshape") }
                .tag(0)
            FriendsView(friendCards: [
                FriendCardView(firstName: "Doeun", username: "billthemuffer", emoji: "🌎", color: Color.wavelengthBlue),
                FriendCardView(firstName: "Andrea", username: "andrea.funggg", emoji: "🪷", color: Color.wavelengthPink),
                FriendCardView(firstName: "Austin", username: "austtnl", emoji: "🌲", color: Color.wavelengthGreen)
                // Add more FriendCardViews here
            ])
            .tabItem { Image(systemName: "square.grid.2x2") }
            .tag(1)
            ChatView()
                .tabItem { Image(systemName: "bubble") }
                .tag(2)
        }
        .accentColor(Color.wavelengthPurple)
    }
}

#Preview {
    ContentView()
}
