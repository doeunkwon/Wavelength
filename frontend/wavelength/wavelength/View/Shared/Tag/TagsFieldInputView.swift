//
//  TagsFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsFieldInputView: View {
    
    @EnvironmentObject var valueTagManager: ValueTagManager
    @EnvironmentObject var interestTagManager: InterestTagManager
    
    let title: String
    let placeholder: String
    let color: Color
    
    @State private var newItem: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: Fonts.body))
                .padding(.bottom, Padding.medium)
            
            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(.wavelengthLightGrey, lineWidth: Border.small)
                    .foregroundColor(.wavelengthOffWhite)
                
                HStack {
                    TextField(placeholder, text: $newItem)
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthDarkGrey)
                    Spacer()
                    Button {
                        if title == Strings.general.values {
                            valueTagManager.tags.append(newItem)
                        } else {
                            interestTagManager.tags.append(newItem)
                        }
                        newItem = ""
                    } label: {
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(.wavelengthGrey)
                    }
                }
                .padding(Padding.medium)
            }
            .padding(.bottom,
                     title == Strings.general.values ?
                     (valueTagManager.tags.count > 0 ? Padding.large : Padding.medium)
                     : (interestTagManager.tags.count > 0 ? Padding.large : Padding.medium)
            )
            
            // Keep in mind that .wrappedValue just copies the underlying VALUE of the binding, NOT the reference.
            TagsView(items: (title == Strings.general.values ? valueTagManager.tags : interestTagManager.tags), color: color, editable: true)
        }
    }
}
