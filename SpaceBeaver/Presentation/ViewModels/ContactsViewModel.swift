//
//  ContactsViewModel.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 09.03.2022.
//

import Foundation
import Combine
import Contacts

class ContactsViewModel: ObservableObject {

    static let shared = ContactsViewModel()

    let premissions = PermissionService()

    private var cancallebles = Set<AnyCancellable>()


    @Published var filter: String = ""
    @Published var suggested: [Contact] = []

    @Published private var contacts: [Contact] = []

    @Published var selected: Contact?

    @Published var accessGranted: Bool = false

    func verifyPermissions() {
        premissions
            .askForContactsPermission()
            .sink(receiveCompletion: { error in
                dump(error)
            }, receiveValue: { [weak self] granted in
                guard let self = self else { return }
                self.accessGranted = granted
                if granted {
                    self.fetchAllContacts()
                }

            }).store(in: &cancallebles)
    }

    func fetchAllContacts() {
        contacts.removeAll()
        CNContactsRepository()
            .fetchContacts()
            .forEach { contact in
                contacts.append(contentsOf: makeViewModel(contact))
            }
    }

    func findContacts(by filter: String) {
        suggested = contacts.filter { $0.isMatched(by: filter) }
    }

    func clearContacts() {
        suggested = []
    }

    private func makeViewModel(_ source: CNContact) -> [Contact] {
        return source
            .phoneNumbers
            .compactMap { item in
                let phoneValue = (item.value as CNPhoneNumber).stringValue
                return Contact(contactId: source.identifier, title: source.fullName, phoneNumber: phoneValue, email: nil)
            }

    }
}
