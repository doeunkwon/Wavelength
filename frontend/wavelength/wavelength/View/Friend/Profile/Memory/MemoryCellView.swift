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
                
                Spacer()
                HStack {
                    
                    
                    Text(String(memory.date.formatted(date: .abbreviated, time: .omitted)))
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthDarkGrey)
                    
                    Spacer()
                    
                    Text((memory.tokens > 0 ? "+" : "") + String(memory.tokens))
                        .font(.system(size: Fonts.body))
                        .foregroundColor(.wavelengthTokenOrange)
                }
                Text(memory.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthText)
                Text(memory.content)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthDarkGrey)
                
                Spacer()
            }
            .padding(Padding.large)
            .frame(maxHeight: 110)
            .background(.wavelengthOffWhite) // Set text color
            .cornerRadius(CornerRadius.medium) // Add corner radius
        }
        .sheet(isPresented: $showMemoryViewModal) {
            MemoryView(memory: memory)
        }
    }
    
}

#Preview {
    MemoryCellView(memory: Mock.memory1)
}
