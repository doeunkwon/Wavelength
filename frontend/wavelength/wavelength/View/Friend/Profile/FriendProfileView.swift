//
//  FriendProfileView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct FriendProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showMemoriesViewSheet = false
    @State private var showScoreViewSheet = false

    @ObservedObject private var friend: Friend
    
    @StateObject private var friendProfileViewModel: FriendProfileViewModel
    @StateObject private var friendProfileToastManager = ToastManager()
    
    @State private var showConfirmDeleteAlert: Bool = false
    @State private var showConfirmScoreAlert: Bool = false
    
    init(user: User, friend: Friend, friends: [Friend]) {
        self.friend = friend
        self._friendProfileViewModel = StateObject(wrappedValue: FriendProfileViewModel(user: user, friend: friend, friends: friends))
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                ZStack (alignment: .bottom) {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: Padding.xlarge) {
                            
                            HeaderView(emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, tokenCount: friend.tokenCount)
                            
                            HStack(alignment: .center, spacing: Padding.large) {
                                if friend.scorePercentage != -1 {
                                    ButtonView(title: Strings.Profile.percentageScore(int: friend.scorePercentage), color: intToColor(value: friend.scorePercentage)) {
                                        showScoreViewSheet.toggle()
                                    }
                                }
                                ButtonView(title: Strings.Memory.memories(int: friend.memoryCount), color: .wavelengthText) {
                                    showMemoriesViewSheet.toggle()
                                }
                            }
                            .shadow(
                                color: ShadowStyle.low.color,
                                radius: ShadowStyle.low.radius,
                                x: ShadowStyle.low.x,
                                y: ShadowStyle.low.y)
                            .fullScreenCover(isPresented: $showScoreViewSheet) {
                                ScoreView(fid: friend.fid, friendFirstName: friend.firstName)
                            }
                            .fullScreenCover(isPresented: $showMemoriesViewSheet) {
                                MemoriesView(friend: friend)
                            }
                            
                            BasicFieldView(title: Strings.Profile.goals, content: friend.goals)
                            
                            DividerLineView()
                            
                            TagsFieldView(title: Strings.Profile.values, items: friend.values, tagColor: friend.color)
                            
                            DividerLineView()
                            
                            TagsFieldView(title: Strings.Profile.interests, items: friend.interests, tagColor: friend.color)
                            
                            Spacer()
                            
                        }
                        .padding(Padding.large)
                        .padding(.bottom, Frame.floatingButtonHeight) /// Additional bottom padding to account for floating wavelength button
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    ScoreWavelengthButtonView(color: friend.color) {
                        showConfirmScoreAlert.toggle()
                    }
                    .alert(Strings.Score.buttonTitle, isPresented: $showConfirmScoreAlert, actions: {
                        Button(Strings.Actions.score) {
                            Task {
                                do {
                                    try await friendProfileViewModel.updateScore(fid: friend.fid)
                                    
                                    DispatchQueue.main.async {
                                        friendProfileToastManager.insertToast(style: .success, message: Strings.Score.updated)
                                    }
                                } catch {
                                    print("Error:", error.localizedDescription)
                                    DispatchQueue.main.async {
                                        friendProfileToastManager.insertToast(style: .error, message: Strings.Errors.network)
                                    }
                                }
                            }
                        }
                        Button(Strings.Actions.cancel, role: .cancel) {}
                    })
                    .padding(.vertical, Padding.large)
                    .shadow(
                        color: ShadowStyle.high.color,
                        radius: ShadowStyle.high.radius,
                        x: ShadowStyle.high.x,
                        y: ShadowStyle.high.y)
                }
                
                if friendProfileViewModel.isLoading {
                    LoadingView()
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                LeftButtonView()
            }), trailing: Menu {
                Button(action: {
                    friendProfileViewModel.showProfileFormViewSheet.toggle()
                }) {
                    Label(Strings.Profile.edit, systemImage: Strings.Icons.person)
                }
                Button(role: .destructive, action: {
                    showConfirmDeleteAlert.toggle()
                }) {
                    Label(Strings.Actions.delete, systemImage: Strings.Icons.trash)
                }
            } label: {
                EllipsisButtonView()
            })
            .alert(Strings.Settings.delete, isPresented: $showConfirmDeleteAlert) {
                Button(Strings.Settings.delete, role: .destructive) {
                    Task {
                        do {
                            try await friendProfileViewModel.deleteFriend(fid: friend.fid, friendMemoryCount: friend.memoryCount, friendTokenCount: friend.tokenCount)
                            dismiss()
                        } catch {
                            print("\(Strings.Errors.generic):", error.localizedDescription)
                            DispatchQueue.main.async {
                    
                                friendProfileToastManager.insertToast(style: .error, message: Strings.Errors.network)
                                
                            }
                        }
                    }
                }
                Button(Strings.Actions.cancel, role: .cancel) {}
                } message: {
                    Text(Strings.Settings.deleteMessage)
                }
                .sheet(isPresented: $friendProfileViewModel.showProfileFormViewSheet) {
                ZStack {
                    ProfileFormView(profileManager: ProfileManager(profile: friend), leadingButtonContent: AnyView(DownButtonView()), buttonConfig: ProfileFormTrailingButtonConfig(title: Strings.Actions.save, action: friendProfileViewModel.completion), navTitle: Strings.Settings.edit, toastManager: friendProfileToastManager)
                    if friendProfileViewModel.isLoading {
                        LoadingView()
                    }
                    
                }
                .toast(toast: $friendProfileToastManager.toast)
                .interactiveDismissDisabled()
            }
            .background(Color.wavelengthBackground)
        }
        .toast(toast: $friendProfileToastManager.toast)
    }
}
