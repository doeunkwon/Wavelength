//
//  MemoryCellView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct MemoryCellView: View {
    
    @State private var showMemoryViewModal = false
    
    let memory: Memory
    
    var body: some View {
        Button {
            showMemoryViewModal.toggle()
        } label: {
            VStack(alignment: .leading, spacing: Padding.medium) {
                HStack {
                    
                    
                    Text(String(memory.date.formatted(date: .abbreviated, time: .omitted)))
                        .font(.system(size: Fonts.body2))
                        .foregroundColor(.wavelengthDarkGrey)
                    
                    Spacer()
                    
                    Text((memory.tokens > 0 ? "+" : "") + String(memory.tokens) + " " + Strings.general.tokens)
                        .font(.system(size: Fonts.body2))
                        .foregroundColor(.wavelengthTokenOrange)
                }
                Text(memory.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthBlack)
                    .frame(height: 20)
                Text(memory.content)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthDarkGrey)
                    .frame(height: 40)
            }
            .padding(Padding.large)
            .frame(maxWidth: .infinity)
            .background(.wavelengthOffWhite) // Set text color
            .cornerRadius(CornerRadius.medium) // Add corner radius
        }
        .sheet(isPresented: $showMemoryViewModal) {
            MemoryView(memory: memory)
        }
    }
    
}

#Preview {
    MemoryCellView(memory: Mock.memory)
}
