//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 1
    
    let user = Mock.user
    
    let friends = Mock.friends
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                SettingsView()
                    .tabItem { Image(systemName: Strings.icons.gearshape) }
                    .tag(0)
                FriendsView(user: user, friends: friends)
                    .tabItem { Image(systemName: Strings.icons.squareGrid2by2) }
                    .tag(1)
//                ChatView()
//                    .tabItem { Image(systemName: Strings.icons.bubble) }
//                    .tag(2)
            }
            .accentColor(Color.wavelengthPurple)
        }
    }
}

#Preview {
    ContentView()
}
