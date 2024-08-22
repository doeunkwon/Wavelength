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
            if editable {
                Button {
                    if flag == Strings.general.values {
                        tagManager.removeValueTag(tag: text)
                    } else if flag == Strings.general.interests {
                        tagManager.removeInterestTag(tag: text)
                    }
                } label: {
                    Image(systemName: Strings.icons.xmark)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthGrey)
                        .padding(.leading, Padding.xsmall)
                }
            }
        }
        .font(.system(size: Fonts.body))
        .padding(.horizontal, Padding.medium + Padding.nudge)
        .padding(.vertical, Padding.medium)
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: CornerRadius.max)
                .stroke(color, lineWidth: Border.medium))
        .background(.wavelengthOffWhite)
        .cornerRadius(CornerRadius.max)
    }
}
