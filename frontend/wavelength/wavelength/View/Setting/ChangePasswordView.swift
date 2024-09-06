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
                    SecureFieldInputView(title: Strings.form.currentPassword, placeholder: "Lmk if you forgot it: bkwon38@gmail.com", binding: $currentPassword)
                    
                    DividerLineView()
                    
                    SecureFieldInputView(title: Strings.form.newPassword, placeholder: "We don't have rules to our passwords!", binding: $newPassword)
                    
                    DividerLineView()
                    
                    SecureFieldInputView(title: Strings.form.confirmPassword, placeholder: "But be responsible", binding: $confirmPassword)
                    
                    Spacer()
                }
                if changePasswordViewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationTitle(Strings.settings.changePassword)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            }, trailing: Button(Strings.form.save) {
                if newPassword == confirmPassword {
                    Task {
                        do {
                            try await changePasswordViewModel.updatePassword(oldPassword: currentPassword, newPassword: newPassword)

                            DispatchQueue.main.async {
                    
                                settingsToastManager.insertToast(style: .success, message: Strings.toast.updatePassword)
                                
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
