//
//  ContactsRepository.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 24.06.2021.
//

import Foundation
import Contacts

class CNContactsRepository {

    func findContact(with identifier: String) -> CNContact? {
        let keys = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let store = CNContactStore()
        do {
            let predicate = CNContact.predicateForContacts(withIdentifiers: [identifier])
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print("Fetched contacts: \(contacts)")
            return contacts.first
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
            return nil
        }
    }

    func findContact(by number: String) -> CNContact? {
        let phone = CNPhoneNumber(stringValue: number.removeAnyNonDigit())
        let keys = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let store = CNContactStore()
        do {
            let predicate = CNContact.predicateForContacts(matching: phone)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print("Fetched contacts: \(contacts)")
            if let contact = contacts.first {
                return contact
            }

            if contacts.isEmpty && number.count > 0 && number.first != "+" {
                let phoneModified = CNPhoneNumber(stringValue: "+" + number)
                let predicate = CNContact.predicateForContacts(matching: phoneModified)
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
                print("Fetched contacts: \(contacts)")
                return contacts.first
            }
            return nil
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
            return nil
        }
    }

    func findContacts(phone numberOrName: String) -> [CNContact] {
        let keys = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let store = CNContactStore()
        do {
            let predicate = CNContact.predicateForContacts(matchingName: numberOrName)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print("Fetched contacts: \(contacts)")
            return contacts
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
            return []
        }
    }

    func findContacts(email numberOrName: String) -> [CNContact] {
        let keys = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor
        ]

        let store = CNContactStore()
        do {
            let predicate = CNContact.predicateForContacts(matchingEmailAddress: numberOrName)
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print("Fetched contacts: \(contacts)")
            return contacts
        } catch {
            print("Failed to fetch contact, error: \(error)")
            // Handle the error
            return []
        }
    }

    func updateContact(contactId: String, name: String) {

        let storedContact = findContact(with: contactId)

        guard let contact = storedContact?.mutableCopy() as? CNMutableContact else { return }

        let (given, family) = splitFullName(name)
        contact.givenName = given
        contact.familyName = family

        // Save the newly created contact
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()

        if storedContact == nil {
            saveRequest.add(contact, toContainerWithIdentifier: nil)
        } else {
            saveRequest.update(contact)
        }

        do {
            try store.execute(saveRequest)
        } catch {
            print("Saving contact failed, error: \(error)")
            // Handle the error
        }
    }

    func addContact(name: String, number: String) -> CNContact? {

        let storedContact = findContact(by: number)

        let contact = storedContact?.mutableCopy() as? CNMutableContact ?? CNMutableContact()

        let (given, family) = splitFullName(name)
        contact.givenName = given
        contact.familyName = family

        contact.phoneNumbers = [CNLabeledValue(
            label: CNLabelPhoneNumberiPhone,
            value: CNPhoneNumber(stringValue: number))]

        // Save the newly created contact
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        
        if storedContact == nil {
            saveRequest.add(contact, toContainerWithIdentifier: nil)
        } else {
            saveRequest.update(contact)
        }

        do {
            try store.execute(saveRequest)

            return contact
        } catch {
            print("Saving contact failed, error: \(error)")
            // Handle the error
            return nil
        }
    }

    func fetchContacts() -> [CNContact] {
        let keys = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        var contacts = [CNContact]()

        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault

        do {
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                contacts.append(contact)
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }

        return contacts
    }

    func fetchContactEmails() -> [CNContact] {
        let keys = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor
        ]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        var contacts = [CNContact]()

        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault

        do {
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                contacts.append(contact)
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }

        return contacts
    }

}

extension CNContactsRepository {

    private func splitFullName(_ value: String) -> (given: String, family: String) {
        let formatter = PersonNameComponentsFormatter()

        guard let components = formatter.personNameComponents(from: value) else {
            return ("", value)
        }

        return (components.givenName ?? "", components.familyName ?? value)
    }

}


extension CNContact {
    var fullName: String {
        let formatter = PersonNameComponentsFormatter()

        var components = PersonNameComponents()
        components.givenName = self.givenName
        components.familyName = self.familyName

        return formatter.string(from: components)
    }
}
