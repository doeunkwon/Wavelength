//
//  EllipsisButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct EllipsisButtonView: View {

    var body: some View {
        Image(systemName: Strings.icons.ellipsis)
            .foregroundColor(.blue)
            .font(Font.body.weight(.semibold))
    }
}
