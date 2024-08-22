//
//  MemoryFieldView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-20.
//

import SwiftUI

struct MemoryFieldView: View {
    
    let memories: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.memory.memories)
                .font(.system(size: Fonts.subtitle))
            ForEach(memories, id: \.self) { memory in
                HStack(alignment: .top) {
                    Circle()
                        .frame(width: 5)
                        .padding(.top, Padding.medium)
                        .padding(.horizontal, Padding.small)
                    Text(memory)
                        .font(.system(size: Fonts.body))
                        .lineSpacing(8)
                }
            }
        }
    }
}
