//
//  ContentView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedTab = 1
    
    let friends = [
        User(uid: "1", firstName: "Doeun", lastName: "Kwon", birthday: "April 12, 2001", username: "billthemuffer", email: "doeun@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Programming", "Travelling", "Boxing"], emoji: "🌎", color: Color.wavelengthBlue),
        User(uid: "2", firstName: "Andrea", lastName: "Fung", birthday: "June 22, 2001", username: "andy pandy", email: "andrea@gmail.com", password: "Abc123", location: "Burnaby", interests: ["Travelling", "Swimming", "Volleyball"], emoji: "🪷", color: Color.wavelengthPink),
        User(uid: "3", firstName: "Austin", lastName: "Lee", birthday: "March 13, 2001", username: "leezy", email: "austin@gmail.com", password: "Abc123", location: "Coquitlam", interests: ["Camping", "Fishing", "Climbing"], emoji: "🌲", color: Color.wavelengthGreen),
        User(uid: "4", firstName: "Patrick", lastName: "Ruszczyk", birthday: "March 28, 2001", username: "pattyrick", email: "patrick@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Soccer", "EDM", "Camping"], emoji: "🦄", color: Color.wavelengthViolet),
        User(uid: "5", firstName: "Hershey", lastName: "Kwon", birthday: "June 7, 2013", username: "hershey bear", email: "hershey@gmail.com", password: "Abc123", location: "Port Moody", interests: ["Steak", "Chicken", "Yam"], emoji: "🐶", color: Color.wavelengthYellow)
    ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SettingsView()
                .tabItem { Image(systemName: Strings.icons.gearshape) }
                .tag(0)
            FriendsView(friends: friends)
                .tabItem { Image(systemName: Strings.icons.squareGrid2by2) }
            .tag(1)
            ChatView()
                .tabItem { Image(systemName: Strings.icons.bubble) }
                .tag(2)
        }
        .accentColor(Color.wavelengthPurple)
    }
}

#Preview {
    ContentView()
}
