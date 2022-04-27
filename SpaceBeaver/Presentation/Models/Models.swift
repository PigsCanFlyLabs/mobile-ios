//
//  Models.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 04.03.2022.
//

import Foundation

struct Contact: Identifiable {
    let id = UUID()
    let contactId: String?
    let title: String

    let phoneNumber: String?
    let email: String?

    var blocked: Bool = false

    static let dummy1 = Contact(contactId: "A", title: "Bella", phoneNumber: "613-681-4814", email: "bellast@gmail.com")
    static let dummy2 = Contact(contactId: "B", title: "Emma", phoneNumber: nil, email: "bellast@gmail.com")
    static let dummy3 = Contact(contactId: "C", title: "Martha", phoneNumber: nil, email: nil)

    func isMatched(by filter: String) -> Bool {
        let filterNormalized = filter.lowercased()
        let phoneNormalized = phoneNumber?.removeAnyNonDigit() ?? ""
        let titleNormalized = title.lowercased()
        return titleNormalized.contains(filterNormalized) || phoneNormalized.contains(filterNormalized)
    }
}

struct Message: Identifiable, Equatable {
    let id: UUID
    let text: String
    let kind: CDMessageType
    let updated: Date

    static let dummy1 = Message(id: UUID(), text: "How far up the mountain are you now?", kind: .incoming, updated: Date())
    static let dummy2 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .outgoing, updated: Date())
    static let dummy3 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .incoming, updated: Date())
    static let dummy4 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .outgoing, updated: Date())
    static let dummy5 = Message(id: UUID(), text: "Tnx.", kind: .incoming, updated: Date())
    static let dummy6 = Message(id: UUID(), text: "How far up the mountain are you now?", kind: .outgoing, updated: Date())
    static let dummy7 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .incoming, updated: Date())
}

struct Dialog: Identifiable {
    let id = UUID()
    let contact: Contact
    let lastUpdated: Date

    var message: String

    static let empty = Dialog(
        contact: Contact.dummy1,
        lastUpdated: Date(),
        message: "")

    static let dummy1 = Dialog(
        contact: Contact.dummy1,
        lastUpdated: Date(),
        message: "")

    static let dummy2 = Dialog(
        contact: Contact.dummy2,
        lastUpdated: Date(),
        message: "")

    static let dummy3 = Dialog(
        contact: Contact.dummy3,
        lastUpdated: Date(),
        message: "")


    func contains(text: String) -> Bool {
        return message.contains(text)
    }
}

struct Device {
    let deviceID: String
    let name: String

    static let dummy = Device(deviceID: "294810HD08HR", name: "SpaceBeaver")
}
