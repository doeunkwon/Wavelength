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
    
    let logo = UIImage(named: "wavelengthLogo")!
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Spacer()
                VStack(spacing: Padding.large * 3) {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.wavelengthPurple)
                        .frame(width: 85)
                    SignInFormView(username: $username, password: $password)
                }
                .padding(.bottom, Padding.large * 3)
                Spacer()
                VStack (spacing: Padding.large) {
                    ButtonView(title: Strings.login.login, color: .wavelengthBackground, backgroundColor: .wavelengthPurple, largeFont: true, action: {
                        viewModel.getToken(username: username, password: password)
                    })
                    .shadow(
                        color: ShadowStyle.standard.color,
                        radius: ShadowStyle.standard.radius,
                        x: ShadowStyle.standard.x,
                        y: ShadowStyle.standard.y)
                    Button(Strings.login.createAProfile) {
                        showSignUpViewModal.toggle()
                    }
                    .font(.system(size: Fonts.body))
                    .foregroundStyle(.blue)
                    .sheet(isPresented: $showSignUpViewModal) {
                        FirstSignUpView(viewModel: viewModel, showModal: $showSignUpViewModal)
                            .interactiveDismissDisabled()
                    }
                }
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
