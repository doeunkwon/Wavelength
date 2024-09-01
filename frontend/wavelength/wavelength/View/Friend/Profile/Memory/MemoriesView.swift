//
//  MemoriesView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-08-08.
//

import SwiftUI

struct MemoriesView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var user: User
    
    @StateObject private var memoriesViewModel = MemoriesViewModel()
    
    @ObservedObject private var friend: Friend
    
    @State private var showNewMemoryViewModal = false
    
    @State private var viewIsLoading: Bool = true
    
    init(friend: Friend) {
        self.friend = friend
    }
    
    var body: some View {
        NavigationStack {
                
            ZStack (alignment: .bottom) {
                
                if viewIsLoading {
                    
                    EmptyLoadingView()
                    
                } else if memoriesViewModel.memories.count == 0 {
                    
                    VStack {
                        Spacer()
                        EmptyStateView(text: Strings.memory.addAMemory, icon: Strings.icons.personLineDottedPerson)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            HStack {
                                Text(String(memoriesViewModel.memories.count) + " " + Strings.memory.memories)
                                    .font(.system(size: Fonts.title))
                                    .foregroundStyle(.wavelengthText)
                                Spacer()
                            }
                            .padding(.horizontal, Padding.large)
                            .padding(.top, Padding.large)
                            .padding(.bottom, Padding.xlarge)
                            
                            let sortedMemories = memoriesViewModel.memories.sorted(by: { $0.date > $1.date })
                            
                            LazyVStack(alignment: .leading, spacing: Padding.large) {
                                ForEach(Array(sortedMemories), id: \.self) { memory in
                                    MemoryCellView(memory: memory, friend: friend, memories: $memoriesViewModel.memories)
                                }
                            }
                            .shadow(
                                color: ShadowStyle.low.color,
                                radius: ShadowStyle.low.radius,
                                x: ShadowStyle.low.x,
                                y: ShadowStyle.low.y)
                            .padding(.horizontal, Padding.large)
                        }
                    }
                    
                }
                
                AddButtonView(showModal: $showNewMemoryViewModal, size: Frame.small, fontSize: Fonts.title) {
                    NewMemoryView(memories: $memoriesViewModel.memories, friend: friend, user: user)
                        .interactiveDismissDisabled()
                }
                .padding(.vertical, Padding.large)
                
                if memoriesViewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: { dismiss() }) {
                DownButtonView()
            })
            .background(.wavelengthBackground)
        }
        .onAppear(perform: {
            Task {
                do {
                    
                    memoriesViewModel.getMemories(fid: friend.fid) { isFinished in
                        if isFinished {
                            viewIsLoading = memoriesViewModel.isLoading
                        }
                    }
                    
                }
            }
        })
    }
}
