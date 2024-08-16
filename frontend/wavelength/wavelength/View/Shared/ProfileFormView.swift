//
//  ProfileFormView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-13.
//

import SwiftUI

struct ProfileFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var isEmojiPickerVisible: Bool = false
    @ObservedObject var friend: Friend
    @StateObject private var editedFriend: Friend
    @StateObject private var tagManager: TagManager
    
    let leadingButtonContent: AnyView
    let trailingButtonLabel: String
    
    init(friend: Friend, leadingButtonContent: AnyView, trailingButtonLabel: String) {
        self.friend = friend
        _tagManager = StateObject(wrappedValue: TagManager(values: friend.values, interests: friend.interests))
        _editedFriend = StateObject(wrappedValue: Friend(fid: friend.fid, scorePercentage: friend.scorePercentage, scoreAnalysis: friend.scoreAnalysis, tokenCount: friend.tokenCount, memoryCount: friend.memoryCount, emoji: friend.emoji, color: friend.color, firstName: friend.firstName, lastName: friend.lastName, goals: friend.goals, interests: friend.interests, values: friend.values))
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
                                
                                
                                ProfilePictureView(emoji: editedFriend.emoji, color: editedFriend.color, frameSize: Frame.friendCard, emojiSize: Fonts.icon)
                            }
                            .shadow(
                                color: ShadowStyle.standard.color,
                                radius: ShadowStyle.standard.radius,
                                x: ShadowStyle.standard.x,
                                y: ShadowStyle.standard.y)
                            
                        }
                        .emojiPicker(
                            isPresented: $isEmojiPickerVisible,
                            selectedEmoji: $editedFriend.emoji
                        )
                        .background(
                            ColorPicker("", selection: $editedFriend.color, supportsOpacity: false)
                                .labelsHidden().opacity(0)
                        )
                        
                        Spacer()
                    }
                    
                    TextFieldInputView(placeholder: Strings.form.firstName, binding: $editedFriend.firstName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.lastName, binding: $editedFriend.lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.form.goals, binding: $editedFriend.goals, isMultiLine: true)
                    
                    DividerLineView()
                    
                    VStack (spacing: Padding.xlarge) {
                        TagsFieldInputView(flag: Strings.general.values, placeholder: Strings.general.addAValue, color: editedFriend.color)
                        
                        TagsFieldInputView(flag: Strings.general.interests, placeholder: Strings.general.addAnInterest, color: editedFriend.color)
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
    ProfileFormView(friend: Mock.friend, leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
}
