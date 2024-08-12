//
//  ChatView.swift
//  wavelength
//
//  Created by Doeun Kwon on 2024-06-10.
//

import SwiftUI

struct ChatView: View {
    
    @State var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    @State var textMessage: String = ""
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) { message in
                        messageView(message: message)
                    }
                }
            }
            .padding(.horizontal)
            HStack {
                TextField(Strings.chat.message, text: $textMessage)
                    .padding()
                    .background(Color.wavelengthLightGrey)
                    .cornerRadius(30)
                Button {
                    print("Sent!")
                } label: {
                    Image(systemName: "paperplane")
                        .font(.system(size: Fonts.title))
                        .accentColor(.wavelengthPurple)
                }
            }
            .padding()
            .padding(.top, 0)
        }
        .background(Color.wavelengthBackground)
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .user { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .user ? .wavelengthText : .wavelengthOffWhite)
                .padding()
                .background(message.sender == .user ? .wavelengthLightGrey : .wavelengthLightPurple)
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
        ChatMessage(id: UUID().uuidString, content: "Hello! I'm Doeun.", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Hey Doeun! How can I help you?", dateCreated: Date(), sender: .ai),
        ChatMessage(id: UUID().uuidString, content: "What's the meaning of the universe?", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Deep question!  Universe = everything, all space & time. Science studies how it works, but meaning is more philosophical. Maybe it's out there, maybe it's for us to decide.", dateCreated: Date(), sender: .ai),
        ChatMessage(id: UUID().uuidString, content: "What should I get Andrea for her birthday?", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Andrea likes crafts, swimming & volleyball! For crafts, maybe a gift certificate to a store or a new kit like jewelry making or painting. For swimming, a new swimsuit, beach towel, goggles or fun floats could be cool! Volleyball ideas are a new ball, kneepads, or a volleyball t-shirt. Anything else you'd like to know about her interests? Might help narrow down the gift! ", dateCreated: Date(), sender: .ai),
        ChatMessage(id: UUID().uuidString, content: "Thanks!", dateCreated: Date(), sender: .user),
        ChatMessage(id: UUID().uuidString, content: "Always.", dateCreated: Date(), sender: .ai)]
}

#Preview {
    ChatView()
}
