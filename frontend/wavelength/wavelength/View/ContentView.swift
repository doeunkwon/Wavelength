//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        NavigationStack {
            if viewModel.isLoggedIn {
            
                TabView(selection: $selectedTab) {
                    SettingsView(isLoggedIn: $viewModel.isLoggedIn)
                        .tag(0)
                    FriendsView(friends: $viewModel.friends, scoreChartData: viewModel.scoreChartData)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(.wavelengthBackground)
                .ignoresSafeArea()
                .onAppear(perform: {
                    viewModel.getUser()
                    viewModel.getFriends()
                    viewModel.getScores()
                })
                
            } else {
                
                SignInView(viewModel: viewModel)
                
            }
        }
    }
}
