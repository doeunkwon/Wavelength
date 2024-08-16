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
    @State private var showChangePasswordViewSheet = false
    @State private var showConfirmDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            SettingsCellView(title: Strings.settings.editProfile, icon: user.emoji, isEmoji: true, action: {
                showUserProfileFormViewSheet.toggle()
            })
            DividerLineView()
            SettingsCellView(title: Strings.settings.changePassword, icon: Strings.icons.lock, action: {
                showChangePasswordViewSheet.toggle()
            })
            DividerLineView()
            SettingsCellView(title: Strings.settings.deleteProfile, icon: Strings.icons.trash, action: {
                showConfirmDeleteAlert.toggle()
            })
            .alert(Strings.settings.confirmDeleteProfile, isPresented: $showConfirmDeleteAlert) {
                Button(Strings.settings.deleteProfile, role: .destructive) {
                            // Perform account deletion logic here
                        }
                Button(Strings.general.cancel, role: .cancel) {}
                    } message: {
                        Text(Strings.settings.confirmDelete)
                    }
            DividerLineView()
            SettingsCellView(title: Strings.settings.logOut, icon: Strings.icons.doorLeftHandOpen, action: {print("Log out tapped!")})
        }
        .sheet(isPresented: $showUserProfileFormViewSheet) {
            UserProfileFormView(user: user, leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
        }
        .sheet(isPresented: $showChangePasswordViewSheet) {
            ChangePasswordView(currentPassword: "", newPassword: "", confirmPassword: "")
        }
    }
}

#Preview {
    SettingsPanelView()
        .environmentObject(Mock.user)
}
