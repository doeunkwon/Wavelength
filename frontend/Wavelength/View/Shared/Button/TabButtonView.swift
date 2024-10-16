//
//  TabButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-31.
//

import SwiftUI

struct TabButtonView: View {
    
    @Binding private var selectedTab: Int
    private let destinationTab: Int
    private let icon: String
    private let color: Color
    
    init(selectedTab: Binding<Int>, destinationTab: Int, icon: String, color: Color) {
        self._selectedTab = selectedTab
        self.destinationTab = destinationTab
        self.icon = icon
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
                        selectedTab = destinationTab
                    }
                } label: {
                    Image(systemName: icon)
                        .font(.system(size: Fonts.subtitle))
                        .accentColor(color)
                }
            }
        }
}
