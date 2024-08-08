//
//  DownButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct DownButtonView: View {
    var action: () -> Void

        var body: some View {
            Button(action: action) {
                Image(systemName: "chevron.down")
                    .foregroundColor(.blue)
                    .font(Font.body.weight(.semibold))
            }
        }
}

#Preview {
    DownButtonView(action: {print("hello")})
}
