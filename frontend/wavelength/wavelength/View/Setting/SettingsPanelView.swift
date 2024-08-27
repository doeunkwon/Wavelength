//
//  SettingsPanelView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-13.
//

import SwiftUI
import SwiftKeychainWrapper

struct SettingsPanelView: View {
    
    @EnvironmentObject var user: User
    
    @StateObject var settingsPanelViewModel = SettingsPanelViewModel()
    
    @State private var showProfileFormViewSheet = false
    @State private var showChangePasswordViewSheet = false
    @State private var showConfirmDeleteAlert = false
    @State private var showConfirmLogoutAlert = false
    
    @Binding var isLoggedIn: Bool
    
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
            SettingsCellView(title: Strings.settings.logOut, icon: Strings.icons.doorLeftHandOpen, action: {
                showConfirmLogoutAlert.toggle()
            })
            .alert(Strings.settings.confirmLogoutProfile, isPresented: $showConfirmLogoutAlert) {
                Button(Strings.settings.logOut) {
                    isLoggedIn = false
                    KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                }
                Button(Strings.general.cancel, role: .cancel) {}
            } message: {
                Text(Strings.settings.confirmLogout)
            }
            DividerLineView()
            SettingsCellView(title: Strings.settings.deleteProfile, icon: Strings.icons.trash, action: {
                showConfirmDeleteAlert.toggle()
            })
            .alert(Strings.settings.confirmDeleteProfile, isPresented: $showConfirmDeleteAlert) {
                Button(Strings.settings.deleteProfile, role: .destructive) {
                    Task {
                        do {
                            try await settingsPanelViewModel.deleteUser()
                            isLoggedIn = false
                            KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                        } catch {
                            // Handle deletion errors
                            print("Deleting error:", error.localizedDescription)
                        }
                    }
                }
                Button(Strings.general.cancel, role: .cancel) {}
                    } message: {
                        Text(Strings.settings.confirmDelete)
                    }
        }
    }
}
