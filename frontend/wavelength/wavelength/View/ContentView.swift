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
    @StateObject var contentToastManager = ToastManager()
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        NavigationStack {
            if viewModel.isLoggedIn {
            
                ZStack {
                    TabView(selection: $selectedTab) {
                        SettingsView(isLoggedIn: $viewModel.isLoggedIn, selectedTab: $selectedTab)
                            .tag(0)
                        FriendsView(scoreChartData: viewModel.scoreChartData, selectedTab: $selectedTab)
                            .tag(1)
                    }
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
                .environmentObject(friendsManager)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(.wavelengthBackground)
                .ignoresSafeArea()
                .onAppear(perform: {
                    selectedTab = 1
                    Task {
                        do {
                            friendsManager.friends = try await viewModel.getUserInfo()
                        }
                    }
                })
                
            } else {
                
                SignInView(viewModel: viewModel)
                
            }
        }
        .environmentObject(contentToastManager)
    }
}
