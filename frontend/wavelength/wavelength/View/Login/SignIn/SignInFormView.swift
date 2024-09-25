//
//  SignInFormView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-22.
//

import SwiftUI

struct SignInFormView: View {
    
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        VStack(spacing: 0) {
            TextFieldInputView(placeholder: Strings.Profile.username, binding: $username, isMultiLine: false)
                .padding(Padding.large)
            DividerLineView()
            SecureFieldInputView(placeholder: Strings.Authentication.password, binding: $password)
                .padding(Padding.large)
        }
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .stroke(.wavelengthLightGrey, lineWidth: Border.small)
        )
        .background(Color.wavelengthOffWhite)
        .cornerRadius(CornerRadius.medium)
    }
}

#Preview {
    @State var username: String = ""
    @State var password: String = ""
    return SignInFormView(username: $username, password: $password)
}
