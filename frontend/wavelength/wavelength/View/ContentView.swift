//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI
import SwiftKeychainWrapper

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @StateObject var friendsManager = FriendsManager(friends: [])
    @StateObject var contentToastManager = ToastManager()
    
    @State private var selectedTab = 1
    
    @State private var viewIsLoading: Bool = true
    
    var body: some View {
        
        NavigationStack {
            if viewModel.isLoggedIn {
                
                /// This ZStack is here so I can add the onAppear modifier
                ZStack {
                    if viewIsLoading {
                        EmptyLoadingView()
                    } else {
                        TabView(selection: $selectedTab) {
                            SettingsView(isLoggedIn: $viewModel.isLoggedIn, selectedTab: $selectedTab)
                                .tag(0)
                            FriendsView(scoreChartData: viewModel.scoreChartData, selectedTab: $selectedTab)
                                .tag(1)
                                .environmentObject(friendsManager)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onAppear(perform: {
                            selectedTab = 1
                        })
                        .background(.wavelengthBackground)
                        .ignoresSafeArea()
                    }
                }
                .onAppear(perform: {
                    Task {
                        do {
                            friendsManager.friends = try await viewModel.getUserInfo()
                            viewIsLoading = viewModel.isLoading
                        } catch let error as UserServiceError {
                            switch error {
                            case .unauthorized:
                                self.viewModel.isLoggedIn = false
                                KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                            case .networkError(let underlyingError):
                                print("Network error: \(underlyingError)")
                            case .unknownError(let message):
                                print("Unknown error: \(message)")
                            }
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
