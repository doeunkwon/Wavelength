//
//  MemoryCellView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct MemoryCellView: View {
    
    @EnvironmentObject var user: User
    
    @State private var showMemoryViewModal = false
    
    @ObservedObject var memory: Memory
    @ObservedObject var friend: Friend
    
    @Binding var memories: [Memory]
    
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
                        .font(.system(size: Fonts.body, weight: .medium))
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
            MemoryView(memory: memory, user: user, friend: friend, memories: $memories)
                .interactiveDismissDisabled()
        }
    }
    
}
