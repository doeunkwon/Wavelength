//
//  FirstSignUpView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-26.
//

import SwiftUI

struct FirstSignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var viewModel: ViewModel
    
    @State private var email: String = ""
    @State private var username: String = ""
    
    @Binding private var showModal: Bool
    
    init(viewModel: ViewModel, showModal: Binding<Bool>) {
        self.viewModel = viewModel
        self._showModal = showModal
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: Padding.xlarge) {
                TextFieldInputView(title: Strings.Profile.email, placeholder: Strings.Actions.tapToEdit, binding: $email, isMultiLine: false)
                
                DividerLineView()
                
                TextFieldInputView(title: Strings.Profile.username, placeholder: Strings.Actions.tapToEdit, binding: $username, isMultiLine: false)
                Spacer()
            }
            .padding(Padding.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.wavelengthBackground)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }, label: {
                DownButtonView()
            }), trailing: NavigationLink(destination: SecondSignUpView(email: email, username: username, viewModel: viewModel, showModal: $showModal)) {
                Text("Next")
            })
            .navigationTitle(Strings.Authentication.letsGetStarted)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @State var showModal = false
    return FirstSignUpView(viewModel: ViewModel(), showModal: $showModal)
}
