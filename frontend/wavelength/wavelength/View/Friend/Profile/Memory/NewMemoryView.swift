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
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                ScrollView {
                        
                    VStack (alignment: .leading, spacing: Padding.xlarge) {
                        HStack {
                            Text(Strings.memory.newMemory)
                                .font(.system(size: Fonts.title))
                            Spacer()
                        }
                        
                        DatePicker(
                            Strings.memory.date,
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        
                        DividerLineView()
                        
                        TextField(Strings.memory.title, text: $title, axis: .vertical)
                            .font(.system(size: Fonts.body))
                        
                        DividerLineView()
                        
                        TextField(Strings.memory.content, text: $content, axis: .vertical)
                            .font(.system(size: Fonts.body))
                        
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
            
        }
    }
}

#Preview {
    NewMemoryView()
}
