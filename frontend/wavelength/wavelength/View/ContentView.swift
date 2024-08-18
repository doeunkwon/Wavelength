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
            if contentViewModel.user.uid.isEmpty {
                
                VStack {
                    Spacer()
                    EmptyState(text: Strings.error.networkError, icon: Strings.icons.icloudslash)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.wavelengthBackground)
                
            } else {
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
