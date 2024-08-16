//
//  EditProfileView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct EditProfileView: View {
    
    let user: User
    
    var body: some View {
        ProfileFormView(profileViewModel: ProfileViewModel(profile: user), leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.save)
    }
}

#Preview {
    EditProfileView(user: Mock.user)
}
