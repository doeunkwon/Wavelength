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
    
    init(friend: Friend) {
        self.friend = friend
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                ZStack (alignment: .bottom) {
                    
                    if memoriesViewModel.memories.count == 0 {
                        
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
                                    color: ShadowStyle.subtle.color,
                                    radius: ShadowStyle.subtle.radius,
                                    x: ShadowStyle.subtle.x,
                                    y: ShadowStyle.subtle.y)
                                .padding(.horizontal, Padding.large)
                            }
                        }
                        
                    }
                    
                    ZStack {
                        Circle()
                            .frame(width: 45)
                            .foregroundColor(.wavelengthOffWhite)
                            .shadow(
                                color: ShadowStyle.subtle.color,
                                radius: ShadowStyle.subtle.radius,
                                x: ShadowStyle.subtle.x,
                                y: ShadowStyle.subtle.y)
                        Button {
                            print("Add new friend!")
                            showNewMemoryViewModal.toggle()
                        } label: {
                            Image(systemName: Strings.icons.plus)
                                .font(.system(size: Fonts.title))
                                .accentColor(.wavelengthGrey)
                        }
                        .sheet(isPresented: $showNewMemoryViewModal) {
                            NewMemoryView(memories: $memoriesViewModel.memories, friend: friend, user: user)
                                .interactiveDismissDisabled()
                        }
                    }
                    .padding(.vertical, Padding.large)
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: { dismiss() }) {
                    DownButtonView()
                })
                .background(.wavelengthBackground)
                
                if memoriesViewModel.isLoading {
                    LoadingView()
                }
            }
        }
        .onAppear(perform: {
            memoriesViewModel.getMemories(fid: friend.fid)
        })
    }
}
