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
                            Text(String(memoryCount) + " " + Strings.memory.memories)
                                .font(.system(size: Fonts.title))
                            Spacer()
                        }
                        .padding(.horizontal, Padding.large)
                        .padding(.top, Padding.large)
                        .padding(.bottom, Padding.xlarge)
                        
                        LazyVStack(alignment: .leading, spacing: Padding.large) {
                            ForEach(Array(memories), id: \.self) { memory in
                                MemoryCellView(memory: memory)
                            }
                        }
                        .shadow(
                            color: ShadowStyle.subtle.color,
                            radius: ShadowStyle.subtle.radius,
                            x: ShadowStyle.subtle.x,
                            y: ShadowStyle.subtle.y)
                        .padding(.horizontal, Padding.large)
                    }
                }
                
                ZStack {
                    Circle()
                        .frame(width: 45)
                        .foregroundColor(.wavelengthOffWhite)
                        .shadow(
                            color: ShadowStyle.subtle.color,
                            radius: ShadowStyle.subtle.radius,
                            x: ShadowStyle.subtle.x,
                            y: ShadowStyle.subtle.y)
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
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            })
            .background(.wavelengthBackground)
        }
    }
}

#Preview {
    MemoriesView(memoryCount: 67, memories: Mock.memories)
}
