//
//  NewFriendView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI
import MCEmojiPicker

struct NewFriendView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false
    @State private var emoji: String = "🌞"
    @State private var color: Color = .clear
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var goals: String = ""
    @State private var values: [String] = ["Discipline", "Growth"]
    @State private var interests: [String] = ["Programming", "Nature"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: Padding.xlarge) {
                    HStack {
                        Text(Strings.friend.newFriend)
                            .font(.system(size: Fonts.title))
                        Spacer()
                    }
                    
                    HStack {
                        Text(Strings.general.emoji)
                            .font(.system(size: Fonts.body))
                        Spacer()
                        Button(emoji) {
                            isPresented.toggle()
                        }
                        .font(.system(size: 30))
                        .emojiPicker(
                            isPresented: $isPresented,
                            selectedEmoji: $emoji
                        )
                        
                    }
                    
                    DividerLineView()
                    
                    ColorPicker("Color", selection: $color, supportsOpacity: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(title: Strings.general.firstName, placeholder: "Bright", binding: $firstName, isMultiLine: false)
                    
                    DividerLineView()
                
                    TextFieldInputView(title: Strings.general.lastName, placeholder: "Sun", binding: $lastName, isMultiLine: false)
                    
                    DividerLineView()
                    
                    TextFieldInputView(title: Strings.general.goals, placeholder: "To empower all life on Earth.", binding: $goals, isMultiLine: true)
                    
                    DividerLineView()
                    
                    TagsFieldInputView(title: Strings.general.values, binding: $values, color: color)
                    
                    DividerLineView()
                    
                    TagsFieldInputView(title: Strings.general.interests, binding: $interests, color: color)
                    
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
