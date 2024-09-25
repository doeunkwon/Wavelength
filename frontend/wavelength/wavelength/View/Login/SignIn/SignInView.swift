//
//  SignInView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject private var contentToastManager: ToastManager
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showSignUpViewModal: Bool = false
    
    private let logo = UIImage(named: Strings.Images.wavelengthLogo) ?? UIImage()
    private let logoSize = 85.0
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
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
                            ButtonView(title: Strings.Authentication.signUp, color: .wavelengthText, backgroundColor: .wavelengthOffWhite, action: {
                                showSignUpViewModal.toggle()
                            })
                            .disabled(viewModel.isLoading)
                            .sheet(isPresented: $showSignUpViewModal) {
                                FirstSignUpView(viewModel: viewModel, showModal: $showSignUpViewModal)
                                    .interactiveDismissDisabled()
                                }
                            ButtonView(
                                title: Strings.Authentication.login,
                                color: (viewModel.isLoading || username.isEmpty || password.isEmpty) ? .wavelengthGrey : .wavelengthText,
                                backgroundColor: .wavelengthOffWhite,
                                action: {
                                Task {
                                    do {
                                        try await viewModel.getToken(username: username, password: password)
                                    } catch let error as AuthenticationServiceError {
                                        switch error {
                                        case .invalidCredentials:
                                            contentToastManager.insertToast(style: .error, message: Strings.Authentication.incorrectCredentials)
                                        case .networkError(let underlyingError):
                                            print("\(Strings.Errors.network): \(underlyingError)")
                                            contentToastManager.insertToast(style: .error, message: Strings.Errors.network)
                                        case .unknownError(let message):
                                            print("Unknown error: \(message)")
                                            contentToastManager.insertToast(style: .error, message: "Unknown error")
                                        }
                                    }
                                }
                            })
                            .disabled(viewModel.isLoading || username.isEmpty || password.isEmpty)
                        }
                        .shadow(
                            color: (viewModel.isLoading || username.isEmpty || password.isEmpty) ? .clear : ShadowStyle.low.color,
                            radius: ShadowStyle.low.radius,
                            x: ShadowStyle.low.x,
                            y: ShadowStyle.low.y)
                    }
                    .padding(.bottom, logoSize)
                    Spacer()
                    Text(Strings.General.versionInfo)
                        .font(.system(size: Fonts.body2))
                        .foregroundStyle(.wavelengthGrey)
                        .padding(.top, Padding.large)
                }
                .padding(Padding.large)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.wavelengthBackground)
                .ignoresSafeArea(.keyboard)
                
                if viewModel.isLoading {
                    LoadingView()
                }
                
            }
            
        }
        .toast(toast: $contentToastManager.toast)
    }
}

#Preview {
    SignInView(viewModel: ViewModel())
}
