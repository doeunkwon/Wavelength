//
//  SliderFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

struct SliderFieldView: View {
    
    let title: String
    let pairs: [String: Int]

    var body: some View {
        VStack (alignment: .leading, spacing: Padding.medium) {
            Text(title)
                .font(.system(size: Fonts.body))
                .foregroundStyle(.wavelengthDarkGrey)
            VStack (spacing: 0) {
                // Sort the values dictionary by key
                let sortedValues = pairs.sorted { $0.key < $1.key }
                ForEach(Array(sortedValues.enumerated()), id: \.offset) { index, value in
                    if index != 0 {
                        DividerLine()
                    }
                    SliderCellView(title: value.key, percentage: value.value)
                        .padding(.vertical, Padding.xlarge)
                        .padding(.horizontal, Padding.large)
                }
            }
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(.wavelengthLightGrey, lineWidth: Border.small)
            )
            .background(Color.wavelengthOffWhite)
            .cornerRadius(CornerRadius.medium)
        }
    }
}


#Preview {
    SliderFieldView(title: Strings.profile.values, pairs: ["Discipline": 89, "Integrity": 76, "Growth": 81])
}
