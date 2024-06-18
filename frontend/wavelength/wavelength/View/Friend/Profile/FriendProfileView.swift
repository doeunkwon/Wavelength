//
//  FriendProfileView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

struct FriendProfileView: View {
    
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HeaderView(emoji: user.emoji, color: user.color, firstName: user.firstName, lastName: user.lastName, birthday: user.birthday)
                .padding(.bottom)
            
            BasicFieldView(field: Strings.profile.username, userData: user.username)
                .padding(.bottom)
            
            Divider()
            
            BasicFieldView(field: Strings.profile.email, userData: user.email)
                .padding(.vertical)
            
            Divider()
            
            BasicFieldView(field: Strings.profile.location, userData: user.location)
                .padding(.vertical)
            
            Divider()
            
            InterestFieldView(interests: user.interests, tagColor: user.color)
                .padding(.vertical)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.wavelengthBackground)
    }
}

#Preview {
    FriendProfileView(user: User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "April 12, 2001", username: "billthemuffer", email: "doeun@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing", "EDM"], emoji: "🌎", color: Color.wavelengthBlue))
}
