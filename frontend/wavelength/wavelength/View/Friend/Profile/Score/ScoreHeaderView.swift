//
//  ScoreHeaderView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-28.
//

import SwiftUI

struct ScoreHeaderView: View {
    
    let score: Int
    let friendFirstName: String
    
    var body: some View {
        HStack (alignment: .center, spacing: Padding.large) {
            ZStack (alignment: .center) {
                
                Text("\(score)")
                    .font(.system(size: Fonts.title, weight: .semibold))
                    .foregroundStyle(intToColor(value: score))
                
                // Background for the progress bar
                Circle()
                    .stroke(lineWidth: Border.xlarge)
                    .opacity(0.1)
                    .foregroundColor(intToColor(value: score))
                    .frame(width: Frame.medium)

                // Foreground or the actual progress bar
                Circle()
                    .trim(from: 0.0, to: min(0.8, 1.0))
                    .stroke(style: StrokeStyle(lineWidth: Border.xlarge, lineCap: .round, lineJoin: .round))
                    .foregroundColor(intToColor(value: score))
                    .rotationEffect(Angle(degrees: 270.0))
                    .frame(width: Frame.medium)
                    .shadow(
                        color: ShadowStyle.glow(intToColor(value: score)).color,
                        radius: ShadowStyle.glow(intToColor(value: score)).radius,
                        x: ShadowStyle.glow(intToColor(value: score)).x,
                        y: ShadowStyle.glow(intToColor(value: score)).y)
                
            }
            VStack (alignment: .leading, spacing: Padding.xsmall) {
                Text("You and \(friendFirstName) share")
                    .font(.system(size: Fonts.body2))
                    .foregroundStyle(.wavelengthDarkGrey)
                Text("high compatibility")
                    .font(.system(size: Fonts.subtitle, weight: .semibold))
                    .foregroundStyle(intToColor(value: score))
            }
        }
    }
}

#Preview {
    ScoreHeaderView(score: 78, friendFirstName: "Austin")
}
