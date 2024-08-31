//
//  SettingsButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-31.
//

import SwiftUI

struct SettingsButtonView: View {
    
    @Binding private var selectedTab: Int
    private let color: Color
    
    init(selectedTab: Binding<Int>, color: Color) {
        self._selectedTab = selectedTab
        self.color = color
    }
    
    var body: some View {
            ZStack {
                Circle()
                    .frame(width: Frame.xsmall)
                    .foregroundColor(color.opacity(0.1))
                    .shadow(
                        color: ShadowStyle.glow(color).color,
                        radius: ShadowStyle.glow(color).radius,
                        x: ShadowStyle.glow(color).x,
                        y: ShadowStyle.glow(color).y
                    )

                Button {
                    withAnimation {
                        selectedTab = 0
                    }
                } label: {
                    Image(systemName: Strings.icons.gearshape)
                        .font(.system(size: Fonts.subtitle))
                        .accentColor(color)
                }
            }
        }
}
