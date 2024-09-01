//
//  EmptyLoadingView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-31.
//

import SwiftUI

struct EmptyLoadingView: View {
    var body: some View {
        VStack (spacing: Padding.xlarge) {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.wavelengthBackground)
    }
}

#Preview {
    EmptyLoadingView()
}
