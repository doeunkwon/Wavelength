//
//  SignInView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-22.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showSignUpViewModal: Bool = false
    
    private let logo = UIImage(named: "wavelengthLogo")!
    private let logoSize = 85.0
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Spacer()
                Image(uiImage: logo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.wavelengthLightGrey)
                    .frame(width: logoSize)
                Spacer()
                VStack(spacing: Padding.large) {
                    SignInFormView(username: $username, password: $password)
                    HStack (spacing: Padding.large) {
                        ButtonView(title: Strings.login.logIn, color: .wavelengthText, backgroundColor: .wavelengthOffWhite, action: {
                            viewModel.getToken(username: username, password: password)
                        })
                        ButtonView(title: Strings.login.signUp, color: .wavelengthText, backgroundColor: .wavelengthOffWhite, action: {
                            showSignUpViewModal.toggle()
                        })
                        .sheet(isPresented: $showSignUpViewModal) {
                            FirstSignUpView(viewModel: viewModel, showModal: $showSignUpViewModal)
                                .interactiveDismissDisabled()
                            }
                    }
                    .shadow(
                        color: ShadowStyle.subtle.color,
                        radius: ShadowStyle.subtle.radius,
                        x: ShadowStyle.subtle.x,
                        y: ShadowStyle.subtle.y)
                }
                .padding(.bottom, logoSize)
                Spacer()
                Text("Version 0.1 • Made with ❤️ by Doeun")
                    .font(.system(size: Fonts.body2))
                    .foregroundStyle(.wavelengthGrey)
                    .padding(.top, Padding.large)
            }
            .padding(Padding.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.wavelengthBackground)
            .ignoresSafeArea(.keyboard)
            
        }
    }
}

#Preview {
    SignInView(viewModel: ViewModel())
}
