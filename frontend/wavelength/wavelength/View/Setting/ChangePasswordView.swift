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
    
    private let changePasswordViewModel = ChangePasswordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: Padding.xlarge) {
                SecureFieldInputView(placeholder: Strings.form.currentPassword, binding: $currentPassword)
                
                DividerLineView()
                
                SecureFieldInputView(placeholder: Strings.form.newPassword, binding: $newPassword)
                
                DividerLineView()
                
                SecureFieldInputView(placeholder: Strings.form.confirmPassword, binding: $confirmPassword)
                
                Spacer()
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
                            print("Password successfully updated")
                        } catch {
                            // Handle authentication errors
                            print("Updating error:", error.localizedDescription)
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

#Preview {
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    
    return ChangePasswordView(currentPassword: currentPassword, newPassword: newPassword, confirmPassword: confirmPassword)
}
