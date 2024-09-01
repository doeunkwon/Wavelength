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
    
    @State private var viewIsLoading: Bool = true
    
    var body: some View {
        
        NavigationStack {
            if viewModel.isLoggedIn {
                
                if viewIsLoading {
                    EmptyLoadingView()
                } else {
                    TabView(selection: $selectedTab) {
                        SettingsView(isLoggedIn: $viewModel.isLoggedIn, selectedTab: $selectedTab)
                            .tag(0)
                        FriendsView(scoreChartData: viewModel.scoreChartData, selectedTab: $selectedTab)
                            .tag(1)
                    }
                    .background(.wavelengthBackground)
                    .ignoresSafeArea()
                }
                
            } else {
                
                SignInView(viewModel: viewModel)
                
            }
        }
        .environmentObject(friendsManager)
        .environmentObject(contentToastManager)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear(perform: {
            selectedTab = 1
            Task {
                do {
                    friendsManager.friends = try await viewModel.getUserInfo()
                    viewIsLoading = viewModel.isLoading
                }
            }
        })
    }
}
