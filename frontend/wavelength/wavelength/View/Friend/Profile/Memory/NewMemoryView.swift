//
//  NewMemoryView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct NewMemoryView: View {
    
    @StateObject private var newMemoryViewModel: NewMemoryViewModel
    
    init(memories: Binding<[Memory]>, friend: Friend, user: User) {
        self._newMemoryViewModel = StateObject(wrappedValue: NewMemoryViewModel(memories: memories, friend: friend, user: user))
    }
    
    @StateObject var memory = Memory(mid: "", date: Date(), title: "", content: "", tokens: 0)
    
    var body: some View {
        MemoryFormView(memory: memory, leadingButtonContent: AnyView(DownButtonView()), buttonConfig: MemoryFormTrailingButtonConfig(title: Strings.form.create, action: newMemoryViewModel.completion), navTitle: Strings.memory.newMemory)
    }
}
