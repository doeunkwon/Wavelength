//
//  Sizes.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-18.
//

import SwiftUI

enum Fonts {
    static let icon: CGFloat = 50
    static let header: CGFloat = 40
    static let title: CGFloat = 24
    static let subtitle: CGFloat = 20
    static let body: CGFloat = 16
    static let body2: CGFloat = 12
    static let body3: CGFloat = 10
}


enum Frame {
    static let large: CGFloat = 150
    static let medium: CGFloat = 80
    static let small: CGFloat = 50
    static let xsmall: CGFloat = 40
    static let dashboardTop: CGFloat = 65
    static let dashboardBottom: CGFloat = 110
    static let friendCard: CGFloat = UIScreen.main.bounds.width / 2 - (Padding.medium * 2) - (Padding.large + (Padding.large / 2))
    static let friendCardBackground: CGFloat = UIScreen.main.bounds.width / 2 - (Padding.large + (Padding.large / 2))
    static let memoryCell: CGFloat = 100
    static let loadingSquare: CGFloat = 55
    static let toastWidth: CGFloat = UIScreen.main.bounds.width - (Padding.xlarge * 2)
    static let floatingButtonHeight: CGFloat = 50
    static let customNavbarHeight: CGFloat = 50
}

enum Padding {
    static let xlarge: CGFloat = 30
    static let large: CGFloat = 20
    static let medium: CGFloat = 10
    static let small: CGFloat = 5
    static let xsmall: CGFloat = 3
    static let min: CGFloat = 1
    static let nudge: CGFloat = 3
}

enum CornerRadius {
    static let max: CGFloat = 100
    static let medium: CGFloat = 8
}

enum Border {
    static let small: CGFloat = 1
    static let medium: CGFloat = 2
    static let large: CGFloat = 3
    static let xlarge: CGFloat = 8
}
