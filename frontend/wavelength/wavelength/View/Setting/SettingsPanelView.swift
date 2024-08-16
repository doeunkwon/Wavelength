//
//  SettingsPanelView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct SettingsPanelView: View {
    
    @EnvironmentObject var user: User
    
    @State private var showUserProfileFormViewSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            SettingsCellView(title: Strings.settings.editProfile, icon: user.emoji, isEmoji: true, action: {
                showUserProfileFormViewSheet.toggle()
            })
            DividerLineView()
            SettingsCellView(title: Strings.settings.changePassword, icon: Strings.icons.lock, action: {print("Change Password tapped!")})
            DividerLineView()
            SettingsCellView(title: Strings.settings.deleteProfile, icon: Strings.icons.trash, action: {print("Delete Profile tapped!")})
            DividerLineView()
            SettingsCellView(title: Strings.settings.logOut, icon: Strings.icons.doorLeftHandOpen, action: {print("Log out tapped!")})
        }
        .sheet(isPresented: $showUserProfileFormViewSheet) {
            UserProfileFormView(user: user, leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
        }
    }
}

#Preview {
    SettingsPanelView()
        .environmentObject(Mock.user)
}
