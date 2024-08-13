//
//  TagsFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsFieldInputView: View {
    
    @EnvironmentObject var tagManager: TagManager
    
    let title: String
    let placeholder: String
    let color: Color
    
    @State private var newItem: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: Fonts.body))
                .padding(.bottom, Padding.medium + Padding.nudge)
            
            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: CornerRadius.max)
                    .stroke(.wavelengthLightGrey, lineWidth: Border.small)
                    .foregroundColor(.wavelengthOffWhite)
                
                HStack {
                    TextField(placeholder, text: $newItem)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthDarkGrey)
                    Spacer()
                    Button {
                        if title == Strings.general.values {
                            tagManager.valuesTags.append(newItem)
                        } else if title == Strings.general.interests {
                            tagManager.interestTags.append(newItem)
                        }
                        newItem = ""
                    } label: {
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(.wavelengthGrey)
                    }
                }
                .padding(Padding.medium + Padding.nudge)
            }
            .padding(.bottom,
                     title == Strings.general.values ?
                     (tagManager.valuesTags.count > 0 ? Padding.large : Padding.medium)
                     : (tagManager.interestTags.count > 0 ? Padding.large : Padding.medium)
            )
            
            // Keep in mind that .wrappedValue just copies the underlying VALUE of the binding, NOT the reference.
            TagsView(tags: (title == Strings.general.values ? tagManager.valuesTags : tagManager.interestTags), color: color, editable: true, flag: title)
        }
    }
}
