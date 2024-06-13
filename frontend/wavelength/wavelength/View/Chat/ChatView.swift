//
//  ChatView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ChatView: View {
    
    @State var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(chatMessages, id: \.id) { message in
                    messageView(message: message)
                }
            }
        }
        .padding(.horizontal)
        .background(Color.background)
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .user { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .user ? .white : .black)
                .padding()
                .background(message.sender == .user ? .wavelengthPurple : .wavelengthLightGrey)
                .cornerRadius(10)
            if message.sender == .ai { Spacer() }
        }
        .padding(.vertical, 4)
    }
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case user
    case ai
}

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Hello world! This is from Doeun.", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Hello world! This is from AI.", dateCreated: Date(), sender: .ai),
        ChatMessage(id: UUID().uuidString, content: "Hello world! This is from Doeun.", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Hello world! This is from AI.", dateCreated: Date(), sender: .ai)]
}

#Preview {
    ChatView()
}
