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
    @EnvironmentObject var contentToastManager: ToastManager
    
    @ObservedObject var settingsToastManager: ToastManager
    @StateObject var settingsPanelToastManager = ToastManager()
    @StateObject var settingsPanelViewModel = SettingsPanelViewModel()
    
    @State private var showChangePasswordViewSheet = false
    @State private var showConfirmDeleteAlert = false
    @State private var showConfirmLogoutAlert = false
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SettingsCellView(title: Strings.Profile.edit, icon: user.emoji, isEmoji: true, action: {
                settingsPanelViewModel.showProfileFormViewSheet.toggle()
            })
            .sheet(isPresented: $settingsPanelViewModel.showProfileFormViewSheet) {
                ZStack {
                    ProfileFormView(profileManager: ProfileManager(profile: user), leadingButtonContent: AnyView(DownButtonView()), buttonConfig: ProfileFormTrailingButtonConfig(title: Strings.Actions.save, action: settingsPanelViewModel.completion), navTitle: Strings.Profile.edit, toastManager: settingsPanelToastManager)
                    if settingsPanelViewModel.isLoading {
                        LoadingView()
                    }
                }
                .toast(toast: $settingsPanelToastManager.toast)
                .interactiveDismissDisabled()
            }
            DividerLineView()
            SettingsCellView(title: Strings.Settings.changePassword, icon: Strings.Icons.lock, action: {
                showChangePasswordViewSheet.toggle()
            })
            .sheet(isPresented: $showChangePasswordViewSheet) {
                ChangePasswordView(currentPassword: "", newPassword: "", confirmPassword: "", settingsToastManager: settingsToastManager)
                    .interactiveDismissDisabled()
            }
            DividerLineView()
            SettingsCellView(title: Strings.Settings.logOut, icon: Strings.Icons.doorOpen, action: {
                showConfirmLogoutAlert.toggle()
            })
            .alert(Strings.Settings.logOut, isPresented: $showConfirmLogoutAlert) {
                Button(Strings.Settings.logOut) {
                    isLoggedIn = false
                    KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                }
                Button(Strings.Actions.cancel, role: .cancel) {}
            } message: {
                Text(Strings.Settings.logOutMessage)
            }
            DividerLineView()
            SettingsCellView(title: Strings.Settings.delete, icon: Strings.Icons.trash, action: {
                showConfirmDeleteAlert.toggle()
            })
            .alert(Strings.Settings.delete, isPresented: $showConfirmDeleteAlert) {
                Button(Strings.Settings.delete, role: .destructive) {
                    Task {
                        do {
                            try await settingsPanelViewModel.deleteUser()
                            
                            isLoggedIn = false
                            KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                            
                            DispatchQueue.main.async {
                                
                                contentToastManager.insertToast(style: .success, message: Strings.Settings.deleteToast)
                                
                            }
                        } catch {
                            print("Error:", error.localizedDescription)
                            DispatchQueue.main.async {
                                settingsToastManager.insertToast(style: .error, message: "Network error.")
                            }
                        }
                    }
                }
                Button(Strings.Actions.cancel, role: .cancel) {}
            } message: {
                Text(Strings.Settings.deleteMessage)
            }
        }
    }
}
