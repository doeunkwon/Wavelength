//
//  SignInView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-22.
//

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Spacer()
                VStack(spacing: Padding.large * 3) {
                    Image("wavelengthLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                    SignInFormView(username: $username, password: $password)
                }
                .padding(.bottom, Padding.large * 3)
                Spacer()
                VStack (spacing: Padding.large) {
                    ButtonView(title: Strings.login.logIn, color: .wavelengthBackground, backgroundColor: .wavelengthPurple, largeFont: true, action: {
                        viewModel.getToken(username: username, password: password)
                        if viewModel.bearerToken != "" {
                            print("login success")
                        }
                    })
                    .shadow(
                        color: ShadowStyle.glow(.wavelengthPurple).color,
                        radius: ShadowStyle.glow(.wavelengthPurple).radius,
                        x: ShadowStyle.glow(.wavelengthPurple).x,
                        y: ShadowStyle.glow(.wavelengthPurple).y)
                    Text(Strings.login.createAnAccount)
                        .font(.system(size: Fonts.body))
                        .foregroundStyle(.blue)
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
    SignInView()
        .environmentObject(ViewModel())
}
