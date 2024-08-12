//
//  EllipsisButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct EllipsisButtonView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: Strings.icons.ellipsis)
                .foregroundColor(.blue)
                .font(Font.body.weight(.semibold))
        }
    }
}

#Preview {
    EllipsisButtonView(action: {print("hi")})
}
