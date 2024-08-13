//
//  NewMemoryView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct NewMemoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var date = Date()
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var tokens: Int = 0
    
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                ScrollView {
                        
                    VStack (alignment: .leading, spacing: Padding.xlarge) {
                        
                        Button(action: {
                            withAnimation {
                                showDatePicker.toggle()
                            }
                        }) {
                            HStack (alignment: .center) {
                                Text(String(date.formatted(date: .long, time: .omitted)))
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
                                selection: $date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        DividerLineView()
                        
                        TextFieldInputView(title: Strings.memory.title, placeholder: Strings.memory.title, binding: $title, isMultiLine: true)
                        
                        DividerLineView()
                        
                        TextFieldInputView(title: Strings.memory.content, placeholder: Strings.memory.content, binding: $content, isMultiLine: true)
                        
                        Spacer()
                    }
                    .padding(Padding.large)
                }
                
                ZStack (alignment: .center) {
                    RoundedRectangle(cornerRadius: CornerRadius.max)
                        .frame(width: 180, height: 50)
                        .foregroundColor(.wavelengthOffWhite)
                        .shadow(
                            color: ShadowStyle.standard.color,
                            radius: ShadowStyle.standard.radius,
                            x: ShadowStyle.standard.x,
                            y: ShadowStyle.standard.y)
                    HStack (alignment: .center, spacing: Padding.large) {
                        
                        Button {
                            tokens -= 1
                        } label: {
                            Image(systemName: Strings.icons.chevronLeft)
                                .font(Font.body.weight(.semibold))
                                .foregroundColor(.wavelengthTokenOrange)
                        }
                        
                        Text((tokens > 0 ? "+" : "") + "\($tokens.wrappedValue) \(Strings.general.tokens)")
                            .font(.system(size: Fonts.body))
                            .foregroundColor(.wavelengthTokenOrange)
                        
                        Button {
                            tokens += 1
                        } label: {
                            Image(systemName: Strings.icons.chevronRight)
                                .font(Font.body.weight(.semibold))
                                .foregroundColor(.wavelengthTokenOrange)
                        }
                    }
                }
                .padding(.vertical, Padding.large)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: DownButtonView(action: {dismiss()}), trailing: Button(Strings.general.create) {
                print("Create memory tapped!")
            })
            .background(.wavelengthBackground)
            .ignoresSafeArea(.keyboard)
            
        }
    }
}

#Preview {
    NewMemoryView()
}
