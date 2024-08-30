//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @StateObject var friendsManager = FriendsManager(friends: [])
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        NavigationStack {
            if viewModel.isLoggedIn {
            
                TabView(selection: $selectedTab) {
                    SettingsView(isLoggedIn: $viewModel.isLoggedIn)
                        .tag(0)
                    FriendsView(scoreChartData: viewModel.scoreChartData)
                        .tag(1)
                }
                .environmentObject(friendsManager)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(.wavelengthBackground)
                .ignoresSafeArea()
                .onAppear(perform: {
                    selectedTab = 1
                    viewModel.getUser()
                    Task {
                        do {
                            friendsManager.friends = await viewModel.getFriends()
                        }
                    }
                    viewModel.getUserScores()
                })
                
            } else {
                
                SignInView(viewModel: viewModel)
                
            }
        }
    }
}
