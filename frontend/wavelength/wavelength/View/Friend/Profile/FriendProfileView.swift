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
    @State private var showProfileFormViewSheet = false

    @ObservedObject private var friend: Friend
    
    @StateObject private var friendProfileViewModel: FriendProfileViewModel
    
    @State private var showConfirmDeleteAlert: Bool = false
    
    init(user: User, friend: Friend) {
        self.friend = friend
        self._friendProfileViewModel = StateObject(wrappedValue: FriendProfileViewModel(user: user, friend: friend))
    }
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Padding.xlarge) {
                    
                    HeaderView(emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, tokenCount: friend.tokenCount)
                    
                    HStack(alignment: .center, spacing: Padding.large) {
                        ButtonView(title: String(friend.scorePercentage) + Strings.profile.percentageMatch, color: intToColor(value: friend.scorePercentage)) {
                            showScoreViewSheet.toggle()
                        }
                        ButtonView(title: String(friend.memoryCount) + " " + Strings.memory.memories, color: .wavelengthText) {
                            showMemoriesViewSheet.toggle()
                        }
                    }
                    .shadow(
                        color: ShadowStyle.subtle.color,
                        radius: ShadowStyle.subtle.radius,
                        x: ShadowStyle.subtle.x,
                        y: ShadowStyle.subtle.y)
                    .fullScreenCover(isPresented: $showScoreViewSheet) {
                        ScoreView(fid: friend.fid, friendFirstName: friend.firstName)
                    }
                    .fullScreenCover(isPresented: $showMemoriesViewSheet) {
                        MemoriesView(friend: friend)
                    }
                    
                    BasicFieldView(content: friend.goals)
                    
                    DividerLineView()
                    
                    TagsFieldView(title: Strings.general.values, items: friend.values, tagColor: friend.color)
                    
                    TagsFieldView(title: Strings.general.interests, items: friend.interests, tagColor: friend.color)
    //
    //                DividerLineView()
    //
    //                ValueFieldView(values: friend.values)
    //                    .padding(.vertical, Padding.large)
                    
                    Spacer()
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                LeftButtonView()
            }), trailing: Menu {
                Button(action: {
                    print("Update score tapped!")
                    Task {
                        do {
                            try await friendProfileViewModel.updateScore(fid: friend.fid)
                        } catch {
                            // Handle deletion errors
                            print("Updating score error:", error.localizedDescription)
                        }
                    }
                }) {
                    Label("Update score", systemImage: Strings.icons.waveformPathEcg)
                }
                Button(action: {
                    print("Edit tapped!")
                    showProfileFormViewSheet.toggle()
                }) {
                    Label("Edit profile", systemImage: Strings.icons.person)
                }
                Button(role: .destructive, action: {
                    showConfirmDeleteAlert.toggle()
                }) {
                    Label("Delete", systemImage: Strings.icons.trash)
                }
            } label: {
                EllipsisButtonView()
            })
            .alert(Strings.friend.confirmDeleteProfile, isPresented: $showConfirmDeleteAlert) {
                Button(Strings.friend.deleteProfile, role: .destructive) {
                    Task {
                        do {
                            try await friendProfileViewModel.deleteFriend(fid: friend.fid, friendMemoryCount: friend.memoryCount, friendTokenCount: friend.tokenCount)
                            dismiss()
                        } catch {
                            // Handle deletion errors
                            print("Deleting error:", error.localizedDescription)
                        }
                    }
                }
                Button(Strings.general.cancel, role: .cancel) {}
                } message: {
                    Text(Strings.friend.confirmDelete)
                }
            .sheet(isPresented: $showProfileFormViewSheet) {
                ProfileFormView(profileManager: ProfileManager(profile: friend), leadingButtonContent: AnyView(DownButtonView()), buttonConfig: ProfileFormTrailingButtonConfig(title: Strings.form.save, action: friendProfileViewModel.completion), navTitle: Strings.settings.editProfile)
                    .interactiveDismissDisabled()
            }
            .background(Color.wavelengthBackground)
        }
    }
}
