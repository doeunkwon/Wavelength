//
//  MemoriesView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct MemoriesView: View {
    @Environment(\.dismiss) private var dismiss
    
    let memoryCount: Int
    let memories: [Memory]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text(String(memoryCount) + " " + Strings.memories.memories)
                            .font(.system(size: Fonts.title))
                        Spacer()
                    }
                    .padding(Padding.large)
                    
                    LazyVStack(alignment: .leading, spacing: Padding.large) {
                        ForEach(Array(memories), id: \.self) { memory in
                            MemoryCellView(title: memory.title, content: memory.content, tokens: memory.tokens)
                        }
                    }
                    .shadow(
                        color: ShadowStyle.standard.color,
                        radius: ShadowStyle.standard.radius,
                        x: ShadowStyle.standard.x,
                        y: ShadowStyle.standard.y)
                    .padding(.horizontal, Padding.large)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: DownButtonView {
                dismiss()
            })
            .background(.wavelengthBackground)
        }
    }
}

#Preview {
    MemoriesView(memoryCount: 67, memories: Mock.memories)
}
