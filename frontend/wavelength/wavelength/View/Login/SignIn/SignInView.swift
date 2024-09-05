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
    
    private let logo = UIImage(named: "wavelengthLogo")!
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
                            ButtonView(title: Strings.login.signUp, color: .wavelengthText, backgroundColor: .wavelengthOffWhite, action: {
                                showSignUpViewModal.toggle()
                            })
                            .disabled(viewModel.isLoading)
                            .sheet(isPresented: $showSignUpViewModal) {
                                FirstSignUpView(viewModel: viewModel, showModal: $showSignUpViewModal)
                                    .interactiveDismissDisabled()
                                }
                            ButtonView(
                                title: Strings.login.logIn,
                                color: (viewModel.isLoading || username.isEmpty || password.isEmpty) ? .wavelengthGrey : .wavelengthText,
                                backgroundColor: .wavelengthOffWhite,
                                action: {
                                Task {
                                    do {
                                        try await viewModel.getToken(username: username, password: password)
                                    } catch {
                                        contentToastManager.insertToast(style: .error, message: "Incorrect username or password.")
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
                    Text("Version 0.1 • Made with ❤️ by Doeun")
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
