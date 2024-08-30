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
    
    @State private var showConfirmDeleteAlert: Bool = false
    
    private var memoryViewModel: MemoryViewModel
    
    init(memory: Memory, user: User, friend: Friend, memories: Binding<[Memory]>) {
        self.memory = memory
        self.memoryViewModel = MemoryViewModel(user: user, friend: friend, memories: memories)
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
                            .font(.system(size: Fonts.body))
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
                Button(role: .destructive, action: {
                    showConfirmDeleteAlert.toggle()
                }) {
                    Label("Delete", systemImage: Strings.icons.trash)
                }
            } label: {
                EllipsisButtonView()
            })
            .background(.wavelengthBackground)
            .alert(Strings.memory.confirmDeleteMemory, isPresented: $showConfirmDeleteAlert) {
                Button(Strings.memory.deleteMemory, role: .destructive) {
                    Task {
                        do {
                            try await memoryViewModel.deleteMemory(mid: memory.mid, memoryTokenCount: memory.tokens)
                            dismiss()
                        } catch {
                            // Handle deletion errors
                            print("Deleting error:", error.localizedDescription)
                        }
                    }
                }
                Button(Strings.general.cancel, role: .cancel) {}
                } message: {
                    Text(Strings.memory.confirmDelete)
                }
        }
    }
}
