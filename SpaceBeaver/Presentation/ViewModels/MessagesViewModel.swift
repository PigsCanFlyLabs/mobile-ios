//
//  MessagesViewModel.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 09.03.2022.
//

import Foundation

class MessagesViewModel: ObservableObject {

    static let shared = MessagesViewModel()

    @Published var dialog: Dialog?

    @Published var messages: [Message] = []

    @Published var scrollToLastMessage = true

    func openDialog(_ dialog: Dialog) {
        self.dialog = dialog
//        self.messages = dialog.messages
    }

    func closeDialog() {
        self.dialog = nil
        self.messages = []
    }

    func loadPreviousMessages() {
        self.scrollToLastMessage = false
        self.messages.insert(Message(id: UUID(), text: "Added message", kind: .incoming, updated: Date()), at: 0)
    }

    func sendMessage(text: String) {
        self.messages.append(Message(id: UUID(), text: text, kind: .outgoing, updated: Date()))
    }

    func sendMessage(text: String, to: Contact) {
        self.scrollToLastMessage = true
        guard let dialog = DataManager.shared.storage?.loadDialog(with: to.contactId, name: to.title, contact: to.phoneNumber ?? "") else { return }

        DataManager.shared.storage?.addNewMessage(text: text, dialog: dialog)
        
        self.messages.append(Message(id: UUID(), text: text, kind: .outgoing, updated: Date()))
    }
}
