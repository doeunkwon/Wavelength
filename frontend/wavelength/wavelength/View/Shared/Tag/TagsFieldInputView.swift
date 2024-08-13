//
//  TagsFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsFieldInputView: View {
    
    @EnvironmentObject var tagManager: TagManager
    
    let flag: String
    let placeholder: String
    let color: Color
    
    @State private var newItem: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: CornerRadius.max)
                    .foregroundColor(.wavelengthOffWhite)
                    .shadow(
                        color: ShadowStyle.subtle.color,
                        radius: ShadowStyle.subtle.radius,
                        x: ShadowStyle.subtle.x,
                        y: ShadowStyle.subtle.y)
                
                HStack {
                    TextField(placeholder, text: $newItem)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthText)
                    Spacer()
                    Button {
                        if newItem.count > 0 { /// Makes sure the tag to be added is not an empty string
                            if flag == Strings.general.values {
                                tagManager.valueTags.append(newItem)
                            } else if flag == Strings.general.interests {
                                tagManager.interestTags.append(newItem)
                            }
                            newItem = ""
                        }
                    } label: {
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(.wavelengthGrey)
                    }
                }
                .padding(Padding.medium + Padding.nudge)
            }
            .padding(.bottom,
                     flag == Strings.general.values ?
                     (tagManager.valueTags.count > 0 ? Padding.xlarge : 0)
                     : (tagManager.interestTags.count > 0 ? Padding.xlarge : 0)
                     /// Assumes that the only two values of 'flag' is "Values" and "Interests"
            )
            
            TagsView(tags: (flag == Strings.general.values ? tagManager.valueTags : tagManager.interestTags), color: color, editable: true, flag: flag)
        }
    }
}
