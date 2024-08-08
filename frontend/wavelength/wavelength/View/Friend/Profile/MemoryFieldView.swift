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
            Text(Strings.memories.memories)
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

#Preview {
    MemoryFieldView(memories: ["Wants to go camping this summer 2024 with all the boys from HWSS.", "Has a grad exhibition on May 9."])
}
