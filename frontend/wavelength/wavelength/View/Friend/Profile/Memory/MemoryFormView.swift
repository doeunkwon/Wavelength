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
    
    let leadingButtonContent: AnyView
    let trailingButtonLabel: String
    let navTitle: String
    
    @ObservedObject var memory: Memory
    @StateObject var editedMemory: Memory
    
    init(memory: Memory, leadingButtonContent: AnyView, trailingButtonLabel: String, navTitle: String) {
        self.leadingButtonContent = leadingButtonContent
        self.trailingButtonLabel = trailingButtonLabel
        self.navTitle = navTitle
        self.memory = memory
        _editedMemory = StateObject(wrappedValue: Memory(mid: memory.mid, date: memory.date, title: memory.title, content: memory.content, tokens: memory.tokens))
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
                        
                        TextFieldInputView(placeholder: Strings.memory.title, binding: $editedMemory.title, isMultiLine: false)
                        
                        DividerLineView()
                        
                        TextFieldInputView(placeholder: Strings.memory.content, binding: $editedMemory.content, isMultiLine: true)
                        
                        Spacer()
                    }
                    .padding(Padding.large)
                }
                
                ZStack (alignment: .center) {
                    RoundedRectangle(cornerRadius: CornerRadius.max)
                        .frame(width: 180, height: 50)
                        .foregroundColor(.wavelengthOffWhite)
                        .shadow(
                            color: ShadowStyle.subtle.color,
                            radius: ShadowStyle.subtle.radius,
                            x: ShadowStyle.subtle.x,
                            y: ShadowStyle.subtle.y)
                    HStack (alignment: .center, spacing: Padding.large) {
                        
                        Button {
                            editedMemory.tokens -= 1
                        } label: {
                            Image(systemName: Strings.icons.chevronLeft)
                                .font(Font.body.weight(.semibold))
                                .foregroundColor(.wavelengthTokenOrange)
                        }
                        
                        Text((editedMemory.tokens > 0 ? "+" : "") + "\($editedMemory.tokens.wrappedValue) \(Strings.general.tokens)")
                            .font(.system(size: Fonts.body))
                            .foregroundColor(.wavelengthTokenOrange)
                        
                        Button {
                            editedMemory.tokens += 1
                        } label: {
                            Image(systemName: Strings.icons.chevronRight)
                                .font(Font.body.weight(.semibold))
                                .foregroundColor(.wavelengthTokenOrange)
                        }
                    }
                }
                .padding(.vertical, Padding.large)
            }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                leadingButtonContent
            }, trailing: Button(trailingButtonLabel) {
                Task {
                    do {
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "HH:mm E, d MMM y"
                        let formattedDate = formatter.string(from: editedMemory.date)
                        
                        @StateObject var memoryFormViewModel = MemoryFormViewModel(memory: EncodedMemory(
                            date: memory.date != editedMemory.date ? formattedDate : nil,
                            title: memory.title != editedMemory.title ? editedMemory.title : nil,
                            content: memory.content != editedMemory.content ? editedMemory.content : nil,
                            tokens: memory.tokens != editedMemory.tokens ? editedMemory.tokens : nil)
                        )
                        
                        try await memoryFormViewModel.updateMemory(mid: memory.mid)
                        
                        DispatchQueue.main.async {
                            
                            memory.date = editedMemory.date
                            memory.title = editedMemory.title
                            memory.content = editedMemory.content
                            memory.tokens = editedMemory.tokens
                        }
                        
                    } catch {
                        print("Error updating memory: \(error)")
                    }
                }
            })
            .background(.wavelengthBackground)
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    MemoryFormView(memory: Mock.memory1, leadingButtonContent: AnyView(LeftButtonView()), trailingButtonLabel: Strings.form.save, navTitle: Strings.memory.newMemory)
}
