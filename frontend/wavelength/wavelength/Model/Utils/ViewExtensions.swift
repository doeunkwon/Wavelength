//
//  ViewExtensions.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-30.
//

import SwiftUI

extension View {
    func toast(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
