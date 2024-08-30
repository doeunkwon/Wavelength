//
//  FriendsManager.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-29.
//

import SwiftUI

class FriendsManager: ObservableObject {
    
    @Published var friends: [Friend]
    
    init(friends: [Friend]) {
        self.friends = friends
    }
    
    func addFriend(friend: Friend) {
        friends.append(friend)
    }
    
    func removeFriend(fid: String) {
        friends.removeAll { $0.fid == fid }
    }

}
