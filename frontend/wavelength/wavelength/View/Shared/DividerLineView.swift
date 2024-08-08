//
//  DividerLineView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

struct DividerLineView: View {
    var vertical: Bool?
    let color: Color = .wavelengthLightGrey
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: vertical ?? false ? nil : width)
            .frame(width: vertical ?? false ? width : nil)
            .edgesIgnoringSafeArea(vertical ?? false ? .vertical : .horizontal)

    }
    
}

#Preview {
    DividerLineView()
}
