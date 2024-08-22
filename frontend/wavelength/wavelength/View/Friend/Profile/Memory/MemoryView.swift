//
//  MemoryView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct MemoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var memory: Memory
    
    private var memoryViewModel: MemoryViewModel
    
    init(memory: Memory, user: User, friend: Friend) {
        self.memory = memory
        self.memoryViewModel = MemoryViewModel(user: user, friend: friend)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: Padding.xlarge) {
                    
                    HStack {
                        
                        Text(String(memory.date.formatted(date: .long, time: .omitted)))
                            .font(.system(size: Fonts.body))
                            .foregroundStyle(.wavelengthDarkGrey)
                        
                        Spacer()
                        
                        Text((memory.tokens > 0 ? "+" : "") + "\(memory.tokens) tokens")
                            .font(.system(size: Fonts.body, weight: .medium))
                            .foregroundStyle(.wavelengthTokenOrange)
                    }
                    
                    DividerLineView()

                    Text(memory.title)
                        .font(.system(size: Fonts.body, weight: .medium))
                        .foregroundStyle(.wavelengthText)
                    
                    DividerLineView()
                    
                    Text(memory.content)
                        .font(.system(size: Fonts.body))
                        .foregroundStyle(.wavelengthText)

                    Spacer()
                }
                .padding(Padding.large)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            }, trailing: Menu {
                NavigationLink(destination: MemoryFormView(memory: memory, leadingButtonContent: AnyView(LeftButtonView()), buttonConfig: MemoryFormTrailingButtonConfig(title: Strings.form.save, action: memoryViewModel.completion), navTitle: Strings.memory.editMemory)) {
                    Label("Edit memory", systemImage: Strings.icons.pencil)
                }
                Button(role: .destructive, action: {print("Delete tapped!")}) {
                    Label("Delete", systemImage: Strings.icons.trash)
                }
            } label: {
                EllipsisButtonView()
            })
            .background(.wavelengthBackground)
        }
    }
}
