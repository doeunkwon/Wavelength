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
    @ObservedObject var profileViewModel: ProfileViewModel
    @StateObject private var editedProfileViewModel: ProfileViewModel
    @StateObject private var tagManager: TagManager
    
    let leadingButtonContent: AnyView
    let trailingButtonLabel: String
    
    init(profileViewModel: ProfileViewModel, leadingButtonContent: AnyView, trailingButtonLabel: String) {
        self.profileViewModel = profileViewModel
        _tagManager = StateObject(wrappedValue: TagManager(values: profileViewModel.profile.values, interests: profileViewModel.profile.interests))
        _editedProfileViewModel = if let user = profileViewModel.profile as? User {
            StateObject(wrappedValue: ProfileViewModel(profile: User(uid: user.uid, emoji: user.emoji, color: user.color, firstName: user.firstName, lastName: user.lastName, username: user.username, email: user.email, password: user.password, goals: user.goals, interests: user.interests, scorePercentage: user.scorePercentage, tokenCount: user.tokenCount, memoryCount: user.memoryCount, values: user.values)))
        } else if let friend = profileViewModel.profile as? Friend {
            StateObject(wrappedValue: ProfileViewModel(profile: Friend(fid: friend.fid, scorePercentage: friend.scorePercentage, scoreAnalysis: friend.scoreAnalysis, tokenCount: friend.tokenCount, memoryCount: friend.memoryCount, emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, goals: friend.goals, interests: friend.interests, values: friend.values)))
        } else {
            StateObject(wrappedValue: ProfileViewModel(profile: profileViewModel.profile))
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
                                
                                ProfilePictureView(emoji: editedProfileViewModel.profile.emoji, color: editedProfileViewModel.profile.color, frameSize: Frame.friendCard, emojiSize: Fonts.icon)
                            }
                            .shadow(
                                color: ShadowStyle.standard.color,
                                radius: ShadowStyle.standard.radius,
                                x: ShadowStyle.standard.x,
                                y: ShadowStyle.standard.y)
                            
                        }
                        .emojiPicker(
                            isPresented: $isEmojiPickerVisible,
                            selectedEmoji: $editedProfileViewModel.profile.emoji
                        )
                        .background(
                            ColorPicker("", selection: $editedProfileViewModel.profile.color, supportsOpacity: false)
                                .labelsHidden().opacity(0)
                        )
                        
                        Spacer()
                    }
                    
                    TextFieldInputView(placeholder: Strings.form.firstName, binding: $editedProfileViewModel.profile.firstName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.lastName, binding: $editedProfileViewModel.profile.lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    if let user = editedProfileViewModel.profile as? User {
                        TextFieldInputView(placeholder: Strings.form.email, binding: Binding(get: { user.email }, set: { user.email = $0 }), isMultiLine: false)
                        
                        DividerLineView()
                    }
                    
                    if let user = editedProfileViewModel.profile as? User {
                        TextFieldInputView(placeholder: Strings.form.username, binding: Binding(get: { user.username }, set: { user.username = $0 }), isMultiLine: false)
                        
                        DividerLineView()
                    }
                    
                    TextFieldInputView(placeholder: Strings.form.goals, binding: $editedProfileViewModel.profile.goals, isMultiLine: true)
                    
                    DividerLineView()
                    
                    VStack (spacing: Padding.xlarge) {
                        TagsFieldInputView(flag: Strings.general.values, placeholder: Strings.general.addAValue, color: editedProfileViewModel.profile.color)
                        
                        TagsFieldInputView(flag: Strings.general.interests, placeholder: Strings.general.addAnInterest, color: editedProfileViewModel.profile.color)
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
                print("Create memory tapped!")
            })
            .background(.wavelengthBackground)
        }
        
    }
}


#Preview {
    ProfileFormView(profileViewModel: ProfileViewModel(profile: Mock.user), leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
}
