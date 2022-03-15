//
//  DialogsStore.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import Foundation
import CoreData

class DialogsStore: NSObject {

    var controller: NSFetchedResultsController<CDDialog>?

    var handler: (([Dialog]) -> Void)?

    private override init() {
        super.init()
    }

    static func makeStore() -> DialogsStore {
        let storage = DataManager.shared.storage!
        let store = DialogsStore()

        store.controller = storage.makeDialogsAll()

        store.controller?.delegate = store

        do {
            try store.controller?.performFetch()
        } catch {
            print("Error \(error)")
        }
        return store
    }

    func subscribe(onDataChanged: @escaping ([Dialog]) -> Void) {
        handler = onDataChanged

        let items = controller?.fetchedObjects?
            .compactMap { makeViewModel($0)} ?? []
            .sorted { (lhs, rhs) -> Bool in
                lhs.lastUpdated < rhs.lastUpdated
            }

        handler?(items)
    }

    func makeViewModel(_ source: CDDialog) -> Dialog? {

        let contactId = source.person?.contactId ?? "undefined"
        let name = source.person?.name ?? "undefined"
        let phone = source.person?.contact ?? "undefined"
        let blocked = source.person?.blocked ?? false

        let contact = Contact(contactId: contactId, title: name, phoneNumber: phone, email: nil, blocked: blocked)

        let item = Dialog(contact: contact, lastUpdated: source.lastUpdated ?? Date(), message: source.message ?? "")

        return item
    }
}

extension DialogsStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let items = controller.fetchedObjects?
            .compactMap { $0 as? CDDialog }
            .compactMap { makeViewModel($0)} ?? []
            .sorted { (lhs, rhs) -> Bool in
                lhs.lastUpdated < rhs.lastUpdated
            }

        handler?(items)
    }
}
