//
//  MemoriesView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct MemoriesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showNewMemoryViewModal = false
    
    let memoryCount: Int
    let memories: [Memory]
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
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
                                MemoryCellView(title: memory.title, content: memory.content, tokens: memory.tokens, action: {print("Show memory modal!")})
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
                
                ZStack {
                    Circle()
                        .frame(width: 45)
                        .foregroundColor(.wavelengthOffWhite)
                        .shadow(
                            color: ShadowStyle.standard.color,
                            radius: ShadowStyle.standard.radius,
                            x: ShadowStyle.standard.x,
                            y: ShadowStyle.standard.y)
                    Button {
                        print("Add new friend!")
                        showNewMemoryViewModal.toggle()
                    } label: {
                        Image(systemName: Strings.icons.plus)
                            .font(.system(size: Fonts.title))
                            .accentColor(.wavelengthGrey)
                    }
                    .sheet(isPresented: $showNewMemoryViewModal) {
                        NewMemoryView()
                    }
                }
                .padding(.vertical, Padding.large)
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
