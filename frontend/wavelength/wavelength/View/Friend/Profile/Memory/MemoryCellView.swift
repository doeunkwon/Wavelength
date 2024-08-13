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
            VStack(alignment: .leading, spacing: Padding.medium + Padding.nudge) {
                
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
                
                DividerLineView()
                
                Text(memory.title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: Fonts.body))
                    .foregroundColor(.wavelengthText)
                
                Spacer()
            }
            .padding(Padding.large)
            .frame(maxHeight: Frame.memoryCell)
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
