//
//  TagsFieldInputView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-12.
//

import SwiftUI

struct TagsFieldInputView: View {
    let title: String
    let placeholder: String
    let items: Binding<[String]>
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
                        items.wrappedValue.append(newItem)
                        newItem = ""
                    } label: {
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.body))
                            .foregroundColor(.wavelengthGrey)
                    }
                }
                .padding(Padding.medium)
            }
            .padding(.bottom, items.wrappedValue.count > 0 ? Padding.large : Padding.medium)
            
            // Keep in mind that .wrappedValue just copies the underlying VALUE of the binding, NOT the reference.
            TagsView(items: items.wrappedValue, color: color, editable: true)
        }
    }
}
