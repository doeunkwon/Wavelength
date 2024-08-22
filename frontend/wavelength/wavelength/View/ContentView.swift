//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    // @StateObject var user = Mock.user
    // let friends = Mock.friends
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        NavigationStack {
            if viewModel.user.uid.isEmpty {
                
                VStack {
                    Spacer()
                    EmptyStateView(text: Strings.error.networkError, icon: Strings.icons.icloudslash)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.wavelengthBackground)
                
            } else {
                TabView(selection: $selectedTab) {
                    SettingsView()
                        .tag(0)
                    FriendsView(friends: $viewModel.friends, scoreChartData: viewModel.scoreChartData)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(.wavelengthBackground)
                .ignoresSafeArea()
            }
        }
        .onAppear(perform: {
            viewModel.getUser()
            viewModel.getFriends()
            viewModel.getScores()
        })
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
        .environmentObject(Mock.user)
}
