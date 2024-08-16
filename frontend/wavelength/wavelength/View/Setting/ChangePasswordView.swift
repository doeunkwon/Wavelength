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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            }, trailing: Button(Strings.form.save) {
                print("Save pressed!")
            })
            .padding(Padding.large)
            .background(.wavelengthBackground)
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    ChangePasswordView(currentPassword: "", newPassword: "", confirmPassword: "")
}
