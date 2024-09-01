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
                    
                    VStack (alignment: .leading, spacing: Padding.xlarge) {
                        
                        Button(action: {
                            showDatePicker.toggle()
                        }) {
                            HStack (alignment: .center) {
                                Text(String(editedMemory.date.formatted(date: .long, time: .omitted)))
                                    .foregroundColor(.wavelengthDarkGrey)
                                if showDatePicker {
                                    Image(systemName: Strings.icons.chevronUp)
                                        .font(Font.body.weight(.regular))
                                        .foregroundColor(.wavelengthGrey)
                                } else {
                                    Image(systemName: Strings.icons.chevronDown)
                                        .font(Font.body.weight(.regular))
                                        .foregroundColor(.wavelengthGrey)
                                }
                            }
                            .foregroundColor(.wavelengthText)
                        }

                        if showDatePicker {
                            DatePicker(
                                "",
                                selection: $editedMemory.date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        DividerLineView()
                        
                        TextFieldInputView(title: Strings.memory.title, placeholder: "Mini golf.", binding: $editedMemory.title, isMultiLine: false)
                        
                        DividerLineView()
                        
                        TextFieldInputView(title: Strings.memory.content, placeholder: "One weekend, we were hanging out and he suggested a spontaneous game of mini-golf.", binding: $editedMemory.content, isMultiLine: true)
                        
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
                buttonConfig.action(memory, editedMemory)
                dismiss()
            }) {
                Text(buttonConfig.title)
            })
            .background(.wavelengthBackground)
            .ignoresSafeArea(.keyboard)
        }
    }
}
