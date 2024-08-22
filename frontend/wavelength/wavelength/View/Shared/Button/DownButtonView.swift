//
//  DownButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct DownButtonView: View {

    var body: some View {
        Image(systemName: Strings.icons.chevronDown)
            .foregroundColor(.blue)
            .font(Font.body.weight(.semibold))
    }
}
