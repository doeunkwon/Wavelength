//
//  NewMemoryView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct NewMemoryView: View {
    
    @StateObject var memory = Memory(mid: "", date: Date(), title: "", content: "", tokens: 0)
    
    var body: some View {
        MemoryFormView(memory: memory, leadingButtonContent: AnyView(DownButtonView()), trailingButtonLabel: Strings.form.create)
    }
}

#Preview {
    NewMemoryView()
}
