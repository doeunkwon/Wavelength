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
    let buttonConfig: ProfileFormTrailingButtonConfig
    let navTitle: String
    
    init(profileManager: ProfileManager, leadingButtonContent: AnyView, buttonConfig: ProfileFormTrailingButtonConfig, navTitle: String) {
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
        self.buttonConfig = buttonConfig
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
                                color: ShadowStyle.low.color,
                                radius: ShadowStyle.low.radius,
                                x: ShadowStyle.low.x,
                                y: ShadowStyle.low.y)
                            
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
                    
                    TextFieldInputView(title: Strings.form.firstName, placeholder: "Hershey", binding: $editedProfileManager.profile.firstName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(title: Strings.form.lastName, placeholder: "Bear", binding: $editedProfileManager.profile.lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(title: Strings.form.goals, placeholder: "To locate the cabinet with the best treats hidden inside. Will use super-sniffing powers to track down the delicious scent and get those yummy goodies.", binding: $editedProfileManager.profile.goals, isMultiLine: true)
                    
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
            }, trailing: Button(action: { buttonConfig.action(profileManager, editedProfileManager, tagManager)
            }) {
                Text(buttonConfig.title)
            })
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .background(.wavelengthBackground)
//            .onTapGesture {
//                hideKeyboard()
//            }
        }
        
    }
}

