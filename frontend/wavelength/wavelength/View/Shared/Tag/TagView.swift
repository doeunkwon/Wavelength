//
//  TagView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-19.
//

import SwiftUI

struct TagView: View {
    
    @EnvironmentObject var tagManager: TagManager
    
    let text: String
    let color: Color
    let editable: Bool
    let flag: String?
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: Fonts.body))
                .foregroundColor(.wavelengthText)
            if editable {
                Button {
                    if flag == Strings.Profile.values {
                        tagManager.removeValueTag(tag: text)
                    } else if flag == Strings.Profile.interests {
                        tagManager.removeInterestTag(tag: text)
                    }
                } label: {
                    Image(systemName: Strings.Icons.xmark)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthGrey)
                        .padding(.leading, Padding.xsmall)
                }
            }
        }
        .padding(.horizontal, Padding.medium + Padding.nudge)
        .padding(.vertical, Padding.medium)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: CornerRadius.max)
                .stroke(color, lineWidth: Border.large))
        .background(.wavelengthOffWhite)
        .cornerRadius(CornerRadius.max)
    }
}
