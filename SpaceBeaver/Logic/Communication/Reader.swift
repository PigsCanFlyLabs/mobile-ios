//
//  Reader.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import Foundation

enum Responses {
    /// Unsolicited msg received from satelites
    case message(appId: Int, text: String)

    case msgSent(messageId: Int)
    /// When a queued message has been sent to satelites
    case ack(messageId: Int)
    /// Error
    case error(text: String)
    /// When ready for msgs
    case ready

    /// When a device is set up
    case phone(id: String)

    case undefined
}

extension Responses: Equatable {}

class Reader {
    func parse(line: String) -> Responses {
        let prefixError = "ERROR"
        let prefixReady = "READY"
        let prefixACK = "ACK"
        let prefixMessage = "MSG"
        let prefixMsgId = "MSGID:"
        let prefixPhoneId = "PHONEID:"

        if line.hasPrefix(prefixMsgId) {
            let regex = #"^MSGID:\s+(\d+)$"#

            let groups = line.groups(for: regex)

            if groups.count == 0 {
                return .undefined
            }

            if groups[0].count != 2 {
                return .undefined
            }

            let parts = groups[0]
            let messageId = Int(parts[1]) ?? 0
            return .msgSent(messageId: messageId)
        }

        if line.hasPrefix(prefixPhoneId) {
            let regex = #"^PHONEID:(.+)$"#

            let groups = line.groups(for: regex)

            if groups.count == 0 {
                return .undefined
            }

            if groups[0].count != 2 {
                return .undefined
            }

            let parts = groups[0]
            let phoneId = parts[1].tripWhiteSpaces()
            return .phone(id: phoneId)
        }


        if line.hasPrefix(prefixError) {
            let text = line.dropFirst(prefixError.count)
            return .error(text: String(text).tripResponse())
        }

        if line.hasPrefix(prefixReady) {
            return .ready
        }

        if line.hasPrefix(prefixMessage) {
            let regex = #"^MSG\s+(\d+)\s+(.+)$"#

            let groups = line.groups(for: regex)

            if groups.count == 0 {
                return .undefined
            }

            if groups[0].count != 3 {
                return .undefined
            }

            let parts = groups[0]
            return .message(appId: Int(parts[1]) ?? 0, text: parts[2].tripResponse())
        }

        if line.hasPrefix(prefixACK) {
            let regex = #"^ACK\s+(\d+)$"#

            let groups = line.groups(for: regex)

            if groups.count == 0 {
                return .undefined
            }

            if groups[0].count != 2 {
                return .undefined
            }

            let parts = groups[0]
            return .ack(messageId: Int(parts[1]) ?? 0)
        }

        return .undefined
    }
}
