//
//  Commands.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 12.03.2022.
//

import Foundation

enum Commands {
    /// Query the device to determine if it's set up. If so returns PHONEID: {phone_id}, if not returns ERROR: "{device_id}" not configured.
    case verifySetup

    case deviceId

    case message(text: String, to: String)
}

protocol BaseCommand {
    var header: Data { get }
    var body: Data { get }
}

struct CommandMessage: BaseCommand {
    let to: String
    let text: String

    init(to: String, text: String) {
        self.to = to
        self.text = text

        let builder = CommandBuilder().prepareMessageLength(text: text, receipient: to)
        self.header = builder.header
        self.body = builder.body
    }

    var header: Data

    var body: Data
}
