//
//  SecondSignUpView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-26.
//

import SwiftUI

struct SecondSignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var contentToastManager: ToastManager
    
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
                SecureFieldInputView(title: Strings.form.password, placeholder: "Enter password", binding: $password)
                
                DividerLineView()
                
                SecureFieldInputView(title: Strings.form.confirmPassword, placeholder: "Confirm password", binding: $confirmPassword)
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
            }), trailing: NavigationLink(destination: ThirdSignUpView(email: email, username: username, password: password, login: viewModel.getToken, showModal: $showModal, contentToastManager: contentToastManager)) {
                Text("Next")
            }
                .disabled(password != confirmPassword || password == "" || confirmPassword == "")
            )
            .navigationTitle(Strings.login.chooseAStrongPassword)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
