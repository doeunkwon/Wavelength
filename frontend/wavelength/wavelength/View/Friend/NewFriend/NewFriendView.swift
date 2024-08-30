//
//  NewFriendView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI
import MCEmojiPicker

struct NewFriendView: View {
    
    @StateObject private var newFriendViewModel: NewFriendViewModel
    
    init(friendsManager: FriendsManager) {
        self._newFriendViewModel = StateObject(wrappedValue: NewFriendViewModel(friendsManager: friendsManager))
    }
    
    /// Enter in an arbitrary 'fid' for now. 'fid' will be generated on the backend.
    @StateObject var friend = Friend(fid: "", scorePercentage: 0, scoreAnalysis: "", tokenCount: 0, memoryCount: 0, emoji: "", color: .wavelengthOffWhite, firstName: "", lastName: "", goals: "", interests: [], values: [])
    
    var body: some View {
        ProfileFormView(profileManager: ProfileManager(profile: friend), leadingButtonContent: AnyView(DownButtonView()), buttonConfig: ProfileFormTrailingButtonConfig(title: Strings.form.save, action: newFriendViewModel.completion), navTitle: Strings.friend.newFriend)
    }
}
