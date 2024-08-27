//
//  SecondSignUpView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-26.
//

import SwiftUI

struct SecondSignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var viewModel: ViewModel
    
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @Binding private var showModal: Bool
    
    private let email: String
    private let username: String
    
    init(email: String, username: String, viewModel: ViewModel, showModal: Binding<Bool>) {
        self.email = email
        self.username = username
        self.viewModel = viewModel
        self._showModal = showModal
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: Padding.xlarge) {
                SecureFieldInputView(placeholder: Strings.form.password, binding: $password)
                
                DividerLineView()
                
                SecureFieldInputView(placeholder: Strings.form.confirmPassword, binding: $confirmPassword)
                Spacer()
            }
            .padding(Padding.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.wavelengthBackground)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                LeftButtonView()
            }), trailing: NavigationLink(destination: ThirdSignUpView(email: email, username: username, password: password, login: viewModel.getToken, showModal: $showModal)) {
                Text("Next")
            }
                .disabled(password != confirmPassword || password == "" || confirmPassword == "")
            )
            .navigationTitle(Strings.login.chooseAStrongPassword)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
