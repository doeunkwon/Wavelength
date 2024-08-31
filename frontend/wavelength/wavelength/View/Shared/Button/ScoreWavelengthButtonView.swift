//
//  ScoreWavelengthButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-31.
//

import SwiftUI

struct ScoreWavelengthButtonView: View {
    
    private let color: Color
    private let action: () -> Void
    
    init(color: Color, action: @escaping () -> Void) {
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action, label: {
            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: CornerRadius.max)
                    .frame(width: 210, height: Frame.floatingButtonHeight)
                    .foregroundColor(.clear)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .wavelengthOffWhite.opacity(0.9),
                                .wavelengthOffWhite,
                                .wavelengthOffWhite.opacity(0.9)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .cornerRadius(CornerRadius.max)
                    )
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: CornerRadius.max)
                            .stroke(.wavelengthWhite, lineWidth: Border.medium)
                    )
                HStack (alignment: .center, spacing: Padding.medium) {
                    
                    Text("Score wavelength")
                    Image(systemName: Strings.icons.waveformPathEcg)
                    
                }
                .foregroundStyle(.wavelengthText)
                .font(.system(size: Fonts.body))
            }
        })
    }
}

#Preview {
    ScoreWavelengthButtonView(color: .yellow, action: {
        print("hi")
    })
}
