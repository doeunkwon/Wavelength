//
//  LeftButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct LeftButtonView: View {

    var body: some View {
        Image(systemName: Strings.icons.chevronLeft)
            .foregroundColor(.blue)
            .font(Font.body.weight(.semibold))
    }
}

#Preview {
    LeftButtonView()
}
