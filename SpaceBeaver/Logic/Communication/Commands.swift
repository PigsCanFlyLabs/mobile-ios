//
//  Commands.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 12.03.2022.
//

import Foundation

protocol BaseCommand {
    var header: Data { get }
    var body: Data { get }
    var description: String { get }
}

/// Query the device to determine if it's set up. If so returns PHONEID: {phone_id}, if not returns ERROR: "{device_id}" not configured.
struct QueryDevice: BaseCommand {
    var header: Data
    var body: Data
    var description: String { "{Query Device}" }

    init() {
        let builder = CommandBuilder().prepareQuery()
        self.header = builder.header
        self.body = builder.body
    }
}

struct SetProfile: BaseCommand {
    var header: Data
    var body: Data
    var description: String { "{Set Profile}" }

    init(profileId: String) {
        let builder = CommandBuilder().prepareSetProfile(profile: profileId)

        self.header = builder.header
        self.body = builder.body
    }
}

struct CommandMessage: BaseCommand {
    let to: String
    let text: String
    var description: String { "{Send Message ''\(text)'' ''\(to)''}" }

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
