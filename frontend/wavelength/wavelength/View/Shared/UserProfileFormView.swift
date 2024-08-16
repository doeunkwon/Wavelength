//
//  UserProfileFormView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct UserProfileFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isEmojiPickerVisible: Bool = false
    @ObservedObject var user: User
    @StateObject private var editedUser: User
    @StateObject private var tagManager: TagManager
    
    let leadingButtonContent: AnyView
    let trailingButtonLabel: String
    
    init(user: User, leadingButtonContent: AnyView, trailingButtonLabel: String) {
        self.user = user
        _tagManager = StateObject(wrappedValue: TagManager(values: user.values, interests: user.interests))
        _editedUser = StateObject(wrappedValue: User(uid: user.uid, emoji: user.emoji, color: user.color, firstName: user.firstName, lastName: user.lastName, username: user.username, email: user.email, password: user.password, goals: user.goals, interests: user.interests, scorePercentage: user.scorePercentage, tokenCount: user.tokenCount, memoryCount: user.memoryCount, values: user.values))
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
                                
                                ProfilePictureView(emoji: editedUser.emoji, color: editedUser.color, frameSize: Frame.friendCard, emojiSize: Fonts.icon)
                            }
                            .shadow(
                                color: ShadowStyle.standard.color,
                                radius: ShadowStyle.standard.radius,
                                x: ShadowStyle.standard.x,
                                y: ShadowStyle.standard.y)
                            
                        }
                        .emojiPicker(
                            isPresented: $isEmojiPickerVisible,
                            selectedEmoji: $editedUser.emoji
                        )
                        .background(
                            ColorPicker("", selection: $editedUser.color, supportsOpacity: false)
                                .labelsHidden().opacity(0)
                        )
                        
                        Spacer()
                    }
                    
                    TextFieldInputView(placeholder: Strings.form.firstName, binding: $editedUser.firstName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.lastName, binding: $editedUser.lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.email, binding: $editedUser.email, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.username, binding: $editedUser.username, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.goals, binding: $editedUser.goals, isMultiLine: true)
                    
                    DividerLineView()
                    
                    VStack (spacing: Padding.xlarge) {
                        TagsFieldInputView(flag: Strings.general.values, placeholder: Strings.general.addAValue, color: editedUser.color)
                        
                        TagsFieldInputView(flag: Strings.general.interests, placeholder: Strings.general.addAnInterest, color: editedUser.color)
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
    UserProfileFormView(user: Mock.user, leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
}
