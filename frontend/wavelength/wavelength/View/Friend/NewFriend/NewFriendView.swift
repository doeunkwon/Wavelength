//
//  NewFriendView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct NewFriendView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var emoji: String = ""
    @State private var color: Color = .clear
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var goals: String = ""
    @State private var interests: [String] = []
    @State private var values: [String] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: Padding.xlarge) {
                    HStack {
                        Text(Strings.friend.addNewFriend)
                            .font(.system(size: Fonts.title))
                        Spacer()
                    }
                    
                    DividerLineView()
                    
                    TextField(Strings.general.firstName, text: $firstName, axis: .vertical)
                        .font(.system(size: Fonts.body))
                    
                    DividerLineView()
                    
                    TextField(Strings.general.lastName, text: $lastName, axis: .vertical)
                        .font(.system(size: Fonts.body))
                    
                    DividerLineView()
                    
                    TextField(Strings.general.goals, text: $goals, axis: .vertical)
                        .font(.system(size: Fonts.body))
                    
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
