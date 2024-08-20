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
    
    init(profileManager: ProfileManager, leadingButtonContent: AnyView, trailingButtonLabel: String) {
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
                if profileManager.profile is User {
                    Task {
                        do {
                            var profile = profileManager.profile
                            var editedProfile = editedProfileManager.profile
                            
                            @StateObject var profileFormViewModel = ProfileFormViewModel(
                                user: EncodedUser(
                                    emoji: profile.emoji != editedProfile.emoji ? editedProfile.emoji : nil,
                                    color: profile.color != editedProfile.color ? editedProfile.color.toHex() : nil,
                                    firstName: profile.firstName != editedProfile.firstName ? editedProfile.firstName : nil,
                                    lastName: profile.lastName != editedProfile.lastName ? editedProfile.lastName : nil,
                                    username: {
                                        if let user1 = profile as? User, let user2 = editedProfile as? User {
                                            return user1.username != user2.username ? user2.username : nil
                                        } else {
                                            return nil
                                        }
                                        }(),
                                    email: {
                                        if let user1 = profile as? User, let user2 = editedProfile as? User {
                                            return user1.email != user2.email ? user2.email : nil
                                        } else {
                                            return nil
                                        }
                                        }(),
                                    password: nil,
                                    goals: profile.goals != editedProfile.goals ? editedProfile.goals : nil,
                                    interests: profile.interests != tagManager.interests ? tagManager.interests : nil,
                                    values: profile.values != tagManager.values ? tagManager.values : nil,
                                    scorePercentage: nil,
                                    tokenCount: nil,
                                    memoryCount: nil))
                            
                            try await profileFormViewModel.updateUser()
                            
                            DispatchQueue.main.async {
                                
                                profile.emoji = editedProfile.emoji
                                profile.color = editedProfile.color
                                profile.firstName = editedProfile.firstName
                                profile.lastName = editedProfile.lastName
                                if let user1 = profile as? User, let user2 = editedProfile as? User {
                                    user1.username = user2.username
                                }
                                if let user1 = profile as? User, let user2 = editedProfile as? User {
                                    user1.email = user2.email
                                }
                                profile.goals = editedProfile.goals
                                profile.interests = tagManager.interests
                                profile.values = tagManager.values
                            }
                        } catch {
                          // Handle errors
                            print("Error updating user: \(error)")
                        }
                    }
                } else {
                    print("Friend!")
                }
            })
            .background(.wavelengthBackground)
            .onTapGesture {
                hideKeyboard()
            }
        }
        
    }
}


#Preview {
    ProfileFormView(profileManager: ProfileManager(profile: Mock.user), leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
}
