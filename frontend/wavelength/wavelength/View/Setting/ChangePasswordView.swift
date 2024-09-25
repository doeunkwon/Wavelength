//
//  ChangePasswordView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var currentPassword: String
    @State var newPassword: String
    @State var confirmPassword: String
    
    @ObservedObject var settingsToastManager: ToastManager
    
    @StateObject private var changePasswordViewModel = ChangePasswordViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: Padding.xlarge) {
                    SecureFieldInputView(title: Strings.Authentication.currentPassword, placeholder: Strings.Actions.tapToEdit, binding: $currentPassword)
                    
                    DividerLineView()
                    
                    SecureFieldInputView(title: Strings.Authentication.newPassword, placeholder: Strings.Actions.tapToEdit, binding: $newPassword)
                    
                    DividerLineView()
                    
                    SecureFieldInputView(title: Strings.Authentication.confirmPassword, placeholder: Strings.Actions.tapToEdit, binding: $confirmPassword)
                    
                    Spacer()
                }
                if changePasswordViewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle(Strings.Authentication.changePassword)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            }, trailing: Button(Strings.Actions.save) {
                if newPassword == confirmPassword {
                    Task {
                        do {
                            try await changePasswordViewModel.updatePassword(oldPassword: currentPassword, newPassword: newPassword)

                            DispatchQueue.main.async {
                    
                                settingsToastManager.insertToast(style: .success, message: Strings.Authentication.passwordUpdated)
                                
                            }
                            
                            dismiss()
                        } catch {
                            print("Error:", error.localizedDescription)
                            DispatchQueue.main.async {
                    
                                settingsToastManager.insertToast(style: .error, message: "Network error.")
                                
                            }
                            
                            dismiss()
                        }
                    }
                } else {
                    print("Passwords do not match!")
                }
            })
            .padding(Padding.large)
            .padding(.top, Padding.nudge)
            .background(.wavelengthBackground)
//            .onTapGesture {
//                hideKeyboard()
//            }
        }
    }
}
