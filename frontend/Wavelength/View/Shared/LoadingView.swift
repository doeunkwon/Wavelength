//
//  LoadingView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-30.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: CornerRadius.medium)
                .aspectRatio(1, contentMode: .fit)
                .frame(height: Frame.loadingSquare)
                .foregroundStyle(.wavelengthLightGrey)
                .opacity(0.90)
            ProgressView()
                .scaleEffect(1.5)
            
        }
        
    }
}

#Preview {
    LoadingView()
}
