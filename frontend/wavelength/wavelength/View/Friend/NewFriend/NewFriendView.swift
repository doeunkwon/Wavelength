//
//  NewFriendView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI
import MCEmojiPicker

class TagManager: ObservableObject {
    
    @Published var valueTags: [String] = []
    
    @Published var interestTags: [String] = []

    func removeValueTag(tag: String) {
        valueTags.removeAll { $0 == tag }
    }
    
    func removeInterestTag(tag: String) {
        interestTags.removeAll { $0 == tag }
    }
}


struct NewFriendView: View {
    
    @StateObject var tagManager = TagManager()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEmojiPickerVisible: Bool = false
    @State private var isColorPickerVisible: Bool = false
    
    @State private var emoji: String = "🙈"
    @State private var color: Color = .wavelengthOffWhite
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var goals: String = ""
    @State private var interests: [String] = []
    
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
                                    
                                
                                ProfilePictureView(emoji: emoji, color: color, frameSize: Frame.friendCard, emojiSize: Fonts.icon)
                                    .shadow(
                                        color: ShadowStyle.glow(color).color,
                                        radius: ShadowStyle.glow(color).radius,
                                        x: ShadowStyle.glow(color).x,
                                        y: ShadowStyle.glow(color).radius)
                            }
                            .shadow(
                                color: ShadowStyle.standard.color,
                                radius: ShadowStyle.standard.radius,
                                x: ShadowStyle.standard.x,
                                y: ShadowStyle.standard.y)
                            
                        }
                        .emojiPicker(
                            isPresented: $isEmojiPickerVisible,
                            selectedEmoji: $emoji
                        )
                        .background(
                            ColorPicker("", selection: $color, supportsOpacity: false)
                                .labelsHidden().opacity(0)
                        )
                        
                        Spacer()
                    }
                    
                    TextFieldInputView(placeholder: Strings.general.firstName, binding: $firstName, isMultiLine: false)
                    
                    DividerLineView()
                
                    TextFieldInputView(placeholder: Strings.general.lastName, binding: $lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(placeholder: Strings.general.goals, binding: $goals, isMultiLine: true)
                    
                    DividerLineView()
                    
                    VStack (spacing: Padding.xlarge) {
                        TagsFieldInputView(flag: Strings.general.values, placeholder: Strings.general.addAValue, color: color)
                        
                        TagsFieldInputView(flag: Strings.general.interests, placeholder: Strings.general.addAnInterest, color: color)
                    }
                    .environmentObject(tagManager)
                    
                    Spacer()
                }
                .padding(Padding.large)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: DownButtonView(action: {dismiss()}), trailing: Button(Strings.general.create) {
                print("Create memory tapped!")
            })
            .background(.wavelengthBackground)
        }
    }
}

#Preview {
    NewFriendView()
}
