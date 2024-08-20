//
//  FriendProfileView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct FriendProfileView: View {
    
    let friendProfileViewModel = FriendProfileViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showMemoriesViewSheet = false
    @State private var showProfileFormViewSheet = false
    
    @ObservedObject var friend: Friend
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Padding.xlarge) {
                    
                    HeaderView(emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, tokenCount: friend.tokenCount)
                    
                    HStack(alignment: .center, spacing: Padding.large) {
                        ButtonView(title: String(friend.scorePercentage) + Strings.profile.percentageMatch, color: intToColor(value: friend.scorePercentage), action: {print("Score button tapped")})
                        ButtonView(title: String(friend.memoryCount) + " " + Strings.memory.memories, color: .wavelengthText) {
                            showMemoriesViewSheet.toggle()
                            }
                    }
                    .shadow(
                        color: ShadowStyle.subtle.color,
                        radius: ShadowStyle.subtle.radius,
                        x: ShadowStyle.subtle.x,
                        y: ShadowStyle.subtle.y)
                    .fullScreenCover(isPresented: $showMemoriesViewSheet) {
                        MemoriesView(fid: friend.fid)
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
                    print("Edit tapped!")
                    showProfileFormViewSheet.toggle()
                }) {
                    Label("Edit profile", systemImage: Strings.icons.person)
                }
                Button(role: .destructive, action: {print("Delete tapped!")}) {
                    Label("Delete", systemImage: Strings.icons.trash)
                }
            } label: {
                EllipsisButtonView()
            })
            .sheet(isPresented: $showProfileFormViewSheet) {
                ProfileFormView(profileManager: ProfileManager(profile: friend), leadingButtonContent: AnyView(DownButtonView()), trailingButton: TrailingButtonConfig(title: Strings.form.save, action: friendProfileViewModel.completion), navTitle: Strings.settings.editProfile)
                    .interactiveDismissDisabled()
            }
            .background(Color.wavelengthBackground)
        }
    }
}

#Preview {
    FriendProfileView(friend: Mock.friend)
}
