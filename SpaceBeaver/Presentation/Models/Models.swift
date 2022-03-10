//
//  Models.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 04.03.2022.
//

import Foundation

struct Contact: Identifiable {
    let id = UUID()
    let contactId: String
    let title: String

    let phoneNumber: String?
    let email: String?

    let blocked: Bool = false

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
    enum Kind {
        case incoming
        case outgoing
    }
    let id: UUID
    let text: String
    let kind: Kind

    static let dummy1 = Message(id: UUID(), text: "How far up the mountain are you now?", kind: .incoming)
    static let dummy2 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .outgoing)
    static let dummy3 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .incoming)
    static let dummy4 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .outgoing)
    static let dummy5 = Message(id: UUID(), text: "Tnx.", kind: .incoming)
    static let dummy6 = Message(id: UUID(), text: "How far up the mountain are you now?", kind: .outgoing)
    static let dummy7 = Message(id: UUID(), text: "Beautiful location. Been glassing all day. Looking at a mountain in the distance that has a better vantage point.", kind: .incoming)
}

struct Dialog: Identifiable {
    let id = UUID()
    let contact: Contact
    var messages: [Message]

    static let empty = Dialog(
        contact: Contact.dummy1,
        messages: [
        ])

    static let dummy1 = Dialog(
        contact: Contact.dummy1,
        messages: [
            Message.dummy1,
            Message.dummy2,
            Message.dummy3,
            Message.dummy4,
            Message.dummy5,
            Message.dummy6,
            Message.dummy7,
        ])

    static let dummy2 = Dialog(
        contact: Contact.dummy2,
        messages: [
            Message.dummy1,
            Message.dummy2
        ])

    static let dummy3 = Dialog(
        contact: Contact.dummy3,
        messages: [
            Message.dummy1,
            Message.dummy2
        ])


    func contains(text: String) -> Bool {
        return false
    }
}

struct Device {
    let deviceID: String

    static let dummy = Device(deviceID: "294810HD08HR")
}
