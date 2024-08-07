//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 1
    
    let friends = Mock.friends
    
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
