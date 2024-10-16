//
//  MemoryFormView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-15.
//

import SwiftUI

struct MemoryFormView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showDatePicker = false
    
    private let leadingButtonContent: AnyView
    private let navTitle: String
    private let buttonConfig: MemoryFormTrailingButtonConfig
    
    @ObservedObject private var memory: Memory
    @StateObject private var editedMemory: Memory
    
    init(memory: Memory, leadingButtonContent: AnyView, buttonConfig: MemoryFormTrailingButtonConfig, navTitle: String) {
        self.leadingButtonContent = leadingButtonContent
        self.navTitle = navTitle
        self.memory = memory
        self.buttonConfig = buttonConfig
        self._editedMemory = StateObject(wrappedValue: Memory(mid: memory.mid, date: memory.date, title: memory.title, content: memory.content, tokens: memory.tokens))
    }
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                ScrollView {
                    
                    VStack (alignment: .center, spacing: Padding.xlarge) {
                        
                        HStack {
                            Button(action: {
                                showDatePicker.toggle()
                            }) {
                                HStack (alignment: .center) {
                                    Text(String(editedMemory.date.formatted(date: .long, time: .omitted)))
                                        .foregroundColor(.wavelengthDarkGrey)
                                    if showDatePicker {
                                        Image(systemName: Strings.Icons.chevronUp)
                                            .font(Font.body.weight(.regular))
                                            .foregroundColor(.wavelengthGrey)
                                    } else {
                                        Image(systemName: Strings.Icons.chevronDown)
                                            .font(Font.body.weight(.regular))
                                            .foregroundColor(.wavelengthGrey)
                                    }
                                }
                                .foregroundColor(.wavelengthText)
                            }
                            Spacer()
                        }

                        if showDatePicker {
                            DatePicker(
                                "",
                                selection: $editedMemory.date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(.wheel)
                        }
                        
                        DividerLineView()
                        
                        TextFieldInputView(title: Strings.Memory.title, placeholder: Strings.Actions.tapToEdit, binding: $editedMemory.title, isMultiLine: false)
                        
                        DividerLineView()
                        
                        TextFieldInputView(title: Strings.Memory.content, placeholder: Strings.Actions.tapToEdit, binding: $editedMemory.content, isMultiLine: true)
                        
                        Spacer()
                    }
                    .padding(Padding.large)
                }
                
                TokenCountButtonView(tokens: $editedMemory.tokens)
                .padding(.vertical, Padding.large)
            }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                leadingButtonContent
            }, trailing: Button(action: { 
                Task {
                    try await buttonConfig.action(memory, editedMemory)
                    dismiss()
                }
            }) {
                Text(buttonConfig.title)
            })
            .background(.wavelengthBackground)
            .ignoresSafeArea(.keyboard)
        }
    }
}
