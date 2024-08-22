//
//  SettingsPanelView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI

struct SettingsPanelView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    private var user: User {
        return viewModel.user
    }
    
    @StateObject var settingsPanelViewModel = SettingsPanelViewModel()
    
    @State private var showProfileFormViewSheet = false
    @State private var showChangePasswordViewSheet = false
    @State private var showConfirmDeleteAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            SettingsCellView(title: Strings.settings.editProfile, icon: user.emoji, isEmoji: true, action: {
                showProfileFormViewSheet.toggle()
            })
            .sheet(isPresented: $showProfileFormViewSheet) {
                ProfileFormView(profileManager: ProfileManager(profile: user), leadingButtonContent: AnyView(DownButtonView()), buttonConfig: ProfileFormTrailingButtonConfig(title: Strings.form.save, action: settingsPanelViewModel.completion), navTitle: Strings.settings.editProfile)
                    .interactiveDismissDisabled()
            }
            DividerLineView()
            SettingsCellView(title: Strings.settings.changePassword, icon: Strings.icons.lock, action: {
                showChangePasswordViewSheet.toggle()
            })
            .sheet(isPresented: $showChangePasswordViewSheet) {
                ChangePasswordView(currentPassword: "", newPassword: "", confirmPassword: "")
                    .interactiveDismissDisabled()
            }
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
    }
}

#Preview {
    SettingsPanelView()
        .environmentObject(ViewModel())
}
