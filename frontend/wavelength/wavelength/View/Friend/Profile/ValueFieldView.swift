//
//  ValueFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-06.
//

import SwiftUI

struct ValueFieldView: View {
    let values: [String: Int]

    var body: some View {
        VStack (alignment: .leading, spacing: Padding.medium) {
            Text(Strings.profile.values)
                .font(.system(size: Fonts.body))
                .foregroundStyle(.wavelengthDarkGrey)
            VStack (spacing: 0) {
                // Sort the values dictionary by key
                let sortedValues = values.sorted { $0.key < $1.key }
                ForEach(Array(sortedValues.enumerated()), id: \.offset) { index, value in
                    if index != 0 {
                        DividerLine()
                    }
                    ValueCellView(title: value.key, percentage: value.value)
                        .padding(.vertical, Padding.xlarge)
                        .padding(.horizontal, Padding.large)
                }
            }
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(.wavelengthLightGrey, lineWidth: 1)
            )
        }
    }
}


#Preview {
    ValueFieldView(values: ["Discipline": 89, "Integrity": 76, "Growth": 81])
}
