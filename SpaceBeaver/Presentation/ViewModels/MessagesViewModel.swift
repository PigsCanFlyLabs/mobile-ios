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

    @Published var storeMessages: MessagesStore?

    @Published var messages: [Message] = []

    @Published var scrollToLastMessage = true

    func openDialog(_ dialog: Dialog) {
        DialogsViewModel.shared.unsubscribe()
        self.dialog = dialog
//        self.messages = dialog.messages

        storeMessages = MessagesStore.makeStore(for: dialog.contact.contactId, name: dialog.contact.title, contact: dialog.contact.phoneNumber ?? "")
        storeMessages?.subscribe { [weak self] (result) in
            self?.messages = result
        }
    }

    func closeDialog() {
        DialogsViewModel.shared.subscribe()
        self.dialog = nil
        self.messages = []
        self.storeMessages = nil
    }

    func loadPreviousMessages() {
        self.scrollToLastMessage = false
    }

    func sendMessage(text: String, in dialog: Dialog) {
        self.scrollToLastMessage = true
        let to = dialog.contact
        guard let dialog = DataManager.shared.storage?.loadDialog(with: to.contactId, name: to.title, contact: to.phoneNumber ?? "") else { return }
        DataManager.shared.storage?.addNewMessage(text: text, dialog: dialog)
        SpaceBeaverManager.shared.sendMessage(to: to.phoneNumber ?? "", text: text)
    }

    func sendMessage(text: String, to: Contact) {
        self.scrollToLastMessage = true
        guard let dialog = DataManager.shared.storage?.loadDialog(with: to.contactId, name: to.title, contact: to.phoneNumber ?? "") else { return }

        DataManager.shared.storage?.addNewMessage(text: text, dialog: dialog)
        SpaceBeaverManager.shared.sendMessage(to: to.phoneNumber ?? "", text: text)
    }

    func receivedMessage(text: String, from: String) {
        self.scrollToLastMessage = true
        
        guard let dialog = DataManager.shared.storage?.loadDialog(with: from) else { return }

        DataManager.shared.storage?.addNewMessage(text: text, dialog: dialog, type: .incoming)

//        self.messages.append(Message(id: UUID(), text: text, kind: .incoming, updated: Date()))
    }
}
