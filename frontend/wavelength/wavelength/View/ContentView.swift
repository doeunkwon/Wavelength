//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 1
    
    @StateObject var user = Mock.user
    
    let friends = Mock.friends
    
    var body: some View {
        NavigationStack {
//            FriendsView(user: user, friends: friends)
            TabView(selection: $selectedTab) {
                SettingsView()
                    .tag(0)
                FriendsView(friends: friends)
                    .tag(1)
//                ChatView()
//                    .tabItem { Image(systemName: Strings.icons.bubble) }
//                    .tag(2)
            }
            .environmentObject(user)
//            .accentColor(Color.wavelengthPurple)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(.wavelengthBackground)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
