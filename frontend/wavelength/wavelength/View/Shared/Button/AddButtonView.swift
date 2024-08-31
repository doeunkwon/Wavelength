//
//  AddButtonView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-31.
//

import SwiftUI

struct AddButtonView<Content: View>: View {
    
    @Binding private var showModal: Bool
    private let content: () -> Content
    private let size: CGFloat
    private let fontSize: CGFloat
    private let color: Color?
    
    init(showModal: Binding<Bool>, size: CGFloat, fontSize: CGFloat, color: Color? = nil, content: @escaping () -> Content) {
        self._showModal = showModal
        self.content = content
        self.size = size
        self.fontSize = fontSize
        self.color = color
    }
    
    var body: some View {
            ZStack {
                Circle()
                    .frame(width: size)
                    .foregroundColor(color?.opacity(0.1) ?? .wavelengthOffWhite)
                    .shadow(
                        color: (color != nil) ? ShadowStyle.glow(color!).color : ShadowStyle.high.color,
                        radius: (color != nil) ? ShadowStyle.glow(color!).radius : ShadowStyle.high.radius,
                        x: (color != nil) ? ShadowStyle.glow(color!).x : ShadowStyle.high.x,
                        y: (color != nil) ? ShadowStyle.glow(color!).y : ShadowStyle.high.y
                    )

                Button {
                    showModal.toggle()
                } label: {
                    Image(systemName: Strings.icons.plus)
                        .font(.system(size: fontSize))
                        .accentColor(color ?? .wavelengthGrey)
                }
                .sheet(isPresented: $showModal) {
                    content()
                }
            }
        }
}
