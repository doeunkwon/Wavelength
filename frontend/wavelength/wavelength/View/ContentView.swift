//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    //    @StateObject var user = Mock.user
    // let friends = Mock.friends
    
    @StateObject private var contentViewModel = ContentViewModel()
    
    @State var selectedTab = 1
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                SettingsView()
                    .tag(0)
                FriendsView(friends: contentViewModel.friends)
                    .tag(1)
            }
            .environmentObject(contentViewModel.user)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(.wavelengthBackground)
            .ignoresSafeArea()
        }
        .onAppear(perform: {
            contentViewModel.fetchUser()
            contentViewModel.fetchFriends()
        })
    }
}

#Preview {
    ContentView()
}
