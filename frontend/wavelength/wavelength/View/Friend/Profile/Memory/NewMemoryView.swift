//
//  NewMemoryView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-09.
//

import SwiftUI

struct NewMemoryView: View {
    
    private let newMemoryViewModel: NewMemoryViewModel
    
    init(memories: Binding<[Memory]>, fid: String) {
        self.newMemoryViewModel = NewMemoryViewModel(memories: memories, fid: fid)
    }
    
    @StateObject var memory = Memory(mid: "", date: Date(), title: "", content: "", tokens: 0)
    
    var body: some View {
        MemoryFormView(memory: memory, leadingButtonContent: AnyView(DownButtonView()), buttonConfig: MemoryFormTrailingButtonConfig(title: Strings.form.create, action: newMemoryViewModel.completion), navTitle: Strings.memory.newMemory)
    }
}
