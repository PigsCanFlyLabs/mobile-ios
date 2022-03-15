//
//  MessagesStore.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import Foundation
import CoreData

class MessagesStore: NSObject {

    var controller: NSFetchedResultsController<CDMessage>?

    var handler: (([Message]) -> Void)?

    private override init() {
        super.init()
    }

    static func makeStore(for contactId: String, name: String, contact: String) -> MessagesStore {
        let storage = DataManager.shared.storage!
        let store = MessagesStore()

        let dialog = storage.loadDialog(with: contactId, name: name, contact: contact)

        store.controller = storage.makeMessages(for: dialog)

        store.controller?.delegate = store

        do {
            try store.controller?.performFetch()
        } catch {
            print("Error \(error)")
        }
        return store
    }

    func subscribe(onDataChanged: @escaping ([Message]) -> Void) {
        handler = onDataChanged

        let items = controller?.fetchedObjects?
            .compactMap { makeViewModel($0)} ?? []
            .sorted { (lhs, rhs) -> Bool in
                lhs.updated < rhs.updated
            }

        handler?(items)
    }

    func makeViewModel(_ source: CDMessage) -> Message? {
        let item = Message(id: UUID(), text: source.text ?? "", kind: source.kind, updated: source.received ?? Date())

        return item
    }
}

extension MessagesStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let items = controller.fetchedObjects?
            .compactMap { $0 as? CDMessage }
            .compactMap { makeViewModel($0)} ?? []
            .sorted { (lhs, rhs) -> Bool in
                lhs.updated < rhs.updated
            }

        handler?(items)
    }
}
