//
//  MemoryView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct MemoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let memory: Memory
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: Padding.large) {
                    
                    HStack {
                        
                        Text(String(memory.date.formatted(date: .long, time: .omitted)))
                            .font(.system(size: Fonts.body))
                            .foregroundStyle(.wavelengthDarkGrey)
                        
                        Spacer()
                        
                        Text((memory.tokens > 0 ? "+" : "") + "\(memory.tokens) tokens")
                            .font(.system(size: Fonts.body))
                            .foregroundStyle(.wavelengthTokenOrange)
                    }

                    Text(memory.title)
                        .font(.system(size: Fonts.subtitle))
                    
                    Text(memory.content)
                        .font(.system(size: Fonts.body))
                        .foregroundStyle(.wavelengthText)

                    Spacer()
                }
                .padding(Padding.large)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: DownButtonView(action: {dismiss()}), trailing: Menu {
                Button(action: {print("Edit tapped!")}) {
                    Label("Edit memory", systemImage: Strings.icons.pencil)
                }
                Button(role: .destructive, action: {print("Delete tapped!")}) {
                    Label("Delete", systemImage: Strings.icons.trash)
                }
            } label: {
                EllipsisButtonView(action: {print("edit button tapped")})
            })
            .background(.wavelengthBackground)
        }
    }
}

#Preview {
    MemoryView(memory: Mock.memory)
}
