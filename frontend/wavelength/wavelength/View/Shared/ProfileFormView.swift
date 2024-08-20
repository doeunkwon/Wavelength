//
//  ProfileFormView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct ProfileFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isEmojiPickerVisible: Bool = false
    @ObservedObject var profileManager: ProfileManager
    @StateObject private var editedProfileManager: ProfileManager
    @StateObject private var tagManager: TagManager
    
    let leadingButtonContent: AnyView
    let trailingButtonLabel: String
    let navTitle: String
    
    init(profileManager: ProfileManager, leadingButtonContent: AnyView, trailingButtonLabel: String, navTitle: String) {
        self.profileManager = profileManager
        _tagManager = StateObject(wrappedValue: TagManager(values: profileManager.profile.values, interests: profileManager.profile.interests))
        _editedProfileManager = if let user = profileManager.profile as? User {
            StateObject(wrappedValue: ProfileManager(profile: User(uid: user.uid, emoji: user.emoji, color: user.color, firstName: user.firstName, lastName: user.lastName, username: user.username, email: user.email, password: user.password, goals: user.goals, interests: user.interests, scorePercentage: user.scorePercentage, tokenCount: user.tokenCount, memoryCount: user.memoryCount, values: user.values)))
        } else if let friend = profileManager.profile as? Friend {
            StateObject(wrappedValue: ProfileManager(profile: Friend(fid: friend.fid, scorePercentage: friend.scorePercentage, scoreAnalysis: friend.scoreAnalysis, tokenCount: friend.tokenCount, memoryCount: friend.memoryCount, emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, goals: friend.goals, interests: friend.interests, values: friend.values)))
        } else {
            StateObject(wrappedValue: ProfileManager(profile: profileManager.profile))
        }
        self.leadingButtonContent = leadingButtonContent
        self.trailingButtonLabel = trailingButtonLabel
        self.navTitle = navTitle
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading, spacing: Padding.xlarge) {
                    
                    HStack {
                        
                        Spacer()
                        
                        Menu {
                            Button(Strings.form.pickAnEmoji, action: {
                                isEmojiPickerVisible.toggle()
                            })
                            Button(Strings.form.chooseAColor, action: {
                                UIColorWellHelper.helper.execute?()
                            })
                        } label: {
                            ZStack (alignment: .center) {
                                
                                RoundedRectangle(cornerRadius: CornerRadius.medium)
                                    .aspectRatio(1, contentMode: .fit)
                                    .foregroundColor(.wavelengthOffWhite)
                                    .frame(width: Frame.friendCardBackground)
                                
                                ProfilePictureView(emoji: editedProfileManager.profile.emoji, color: editedProfileManager.profile.color, frameSize: Frame.friendCard, emojiSize: Fonts.icon)
                            }
                            .shadow(
                                color: ShadowStyle.standard.color,
                                radius: ShadowStyle.standard.radius,
                                x: ShadowStyle.standard.x,
                                y: ShadowStyle.standard.y)
                            
                        }
                        .emojiPicker(
                            isPresented: $isEmojiPickerVisible,
                            selectedEmoji: $editedProfileManager.profile.emoji
                        )
                        .background(
                            ColorPicker("", selection: $editedProfileManager.profile.color, supportsOpacity: false)
                                .labelsHidden().opacity(0)
                        )
                        
                        Spacer()
                    }
                    
                    TextFieldInputView(placeholder: Strings.form.firstName, binding: $editedProfileManager.profile.firstName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.lastName, binding: $editedProfileManager.profile.lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    if let user = editedProfileManager.profile as? User {
                        TextFieldInputView(placeholder: Strings.form.email, binding: Binding(get: { user.email }, set: { user.email = $0 }), isMultiLine: false)
                        
                        DividerLineView()
                    }
                    
                    if let user = editedProfileManager.profile as? User {
                        TextFieldInputView(placeholder: Strings.form.username, binding: Binding(get: { user.username }, set: { user.username = $0 }), isMultiLine: false)
                        
                        DividerLineView()
                    }
                    
                    TextFieldInputView(placeholder: Strings.form.goals, binding: $editedProfileManager.profile.goals, isMultiLine: true)
                    
                    DividerLineView()
                    
                    VStack (spacing: Padding.xlarge) {
                        TagsFieldInputView(flag: Strings.general.values, placeholder: Strings.general.addAValue, color: editedProfileManager.profile.color)
                        
                        TagsFieldInputView(flag: Strings.general.interests, placeholder: Strings.general.addAnInterest, color: editedProfileManager.profile.color)
                    }
                    .environmentObject(tagManager)
                    
                    Spacer()
                }
                .padding(Padding.large)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                leadingButtonContent
            }, trailing: Button(trailingButtonLabel) {
                if let user = profileManager.profile as? User {
                    Task {
                        do {
                            let editedProfile = editedProfileManager.profile
                            
                            @StateObject var profileFormViewModel = ProfileFormViewModel(
                                profile: EncodedUser(
                                    emoji: user.emoji != editedProfile.emoji ? editedProfile.emoji : nil,
                                    color: user.color != editedProfile.color ? editedProfile.color.toHex() : nil,
                                    firstName: user.firstName != editedProfile.firstName ? editedProfile.firstName : nil,
                                    lastName: user.lastName != editedProfile.lastName ? editedProfile.lastName : nil,
                                    username: {
                                        if let editedUser = editedProfile as? User {
                                            return user.username != editedUser.username ? editedUser.username : nil
                                        } else {
                                            return nil
                                        }
                                        }(),
                                    email: {
                                        if let editedUser = editedProfile as? User {
                                            return user.email != editedUser.email ? editedUser.email : nil
                                        } else {
                                            return nil
                                        }
                                        }(),
                                    password: nil,
                                    goals: user.goals != editedProfile.goals ? editedProfile.goals : nil,
                                    interests: user.interests != tagManager.interests ? tagManager.interests : nil,
                                    values: user.values != tagManager.values ? tagManager.values : nil,
                                    scorePercentage: nil,
                                    tokenCount: nil,
                                    memoryCount: nil))
                            
                            try await profileFormViewModel.updateUser()
                            
                            DispatchQueue.main.async {
                                
                                user.emoji = editedProfile.emoji
                                user.color = editedProfile.color
                                user.firstName = editedProfile.firstName
                                user.lastName = editedProfile.lastName
                                if let editedUser = editedProfile as? User {
                                    user.username = editedUser.username
                                }
                                if let editedUser = editedProfile as? User {
                                    user.email = editedUser.email
                                }
                                user.goals = editedProfile.goals
                                user.interests = tagManager.interests
                                user.values = tagManager.values
                            }
                        } catch {
                          // Handle errors
                            print("Error updating user: \(error)")
                        }
                    }
                } else if let friend = profileManager.profile as? Friend {
                    Task {
                        do {
                            let editedProfile = editedProfileManager.profile
                            
                            @StateObject var profileFormViewModel = ProfileFormViewModel(
                                profile: EncodedFriend(
                                    emoji: friend.emoji != editedProfile.emoji ? editedProfile.emoji : nil,
                                    color: friend.color != editedProfile.color ? editedProfile.color.toHex() : nil,
                                    firstName: friend.firstName != editedProfile.firstName ? editedProfile.firstName : nil,
                                    lastName: friend.lastName != editedProfile.lastName ? editedProfile.lastName : nil,
                                    goals: friend.goals != editedProfile.goals ? editedProfile.goals : nil,
                                    interests: friend.interests != tagManager.interests ? tagManager.interests : nil,
                                    values: friend.values != tagManager.values ? tagManager.values : nil,
                                    scorePercentage: nil,
                                    tokenCount: nil,
                                    memoryCount: nil))
                            
                            try await profileFormViewModel.updateFriend(fid: friend.fid)
                            
                            DispatchQueue.main.async {
                                
                                friend.emoji = editedProfile.emoji
                                friend.color = editedProfile.color
                                friend.firstName = editedProfile.firstName
                                friend.lastName = editedProfile.lastName
                                friend.goals = editedProfile.goals
                                friend.interests = tagManager.interests
                                friend.values = tagManager.values
                            }
                        } catch {
                          // Handle errors
                            print("Error updating user: \(error)")
                        }
                    }
                }
            })
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(.wavelengthBackground)
            .onTapGesture {
                hideKeyboard()
            }
        }
        
    }
}


#Preview {
    ProfileFormView(profileManager: ProfileManager(profile: Mock.user), leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save, navTitle: Strings.general.newFriend)
}
