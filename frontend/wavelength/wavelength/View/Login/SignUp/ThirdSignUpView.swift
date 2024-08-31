//
//  ThirdSignUpView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-26.
//

import SwiftUI

struct ThirdSignUpView: View {
    
    @StateObject private var signUpViewModel: SignUpViewModel
    @StateObject private var user: User
    
    init(email: String, username: String, password: String, login: @escaping (String, String) async throws -> (), showModal: Binding<Bool>, contentToastManager: ToastManager) {
        self._user = StateObject(wrappedValue: User(uid: "", emoji: "", color: .wavelengthOffWhite, firstName: "", lastName: "", username: username, email: email, password: password, goals: "", interests: [], scorePercentage: 0, tokenCount: 0, memoryCount: 0, values: []))
        self._signUpViewModel = StateObject(wrappedValue: SignUpViewModel(login: login, showModal: showModal, contentToastManager: contentToastManager))
    }
    
    var body: some View {
        ZStack {
            ProfileFormView(profileManager: ProfileManager(profile: user), leadingButtonContent: AnyView(LeftButtonView()), buttonConfig: ProfileFormTrailingButtonConfig(title: Strings.form.create, action: signUpViewModel.completion), navTitle: Strings.login.tellUsAboutYourself)
            if signUpViewModel.isLoading {
                LoadingView()
            }
        }
    }
    
}
