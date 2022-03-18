//
//  Reader.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import Foundation

enum Responses {
    /// Unsolicited msg received from satelites
    case message(appId: Int, text: String, from: String)

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

    case repeatCommand
}

extension Responses: Equatable {}

class ResponseReader {
    func parse(line: String) -> Responses {
        let prefixError = "ERROR"
        let isReady = "READY"
        let isRepeat = "REPEAT"
        let prefixACK = "ACK"
        let prefixMessage = "MSG"
        let prefixMsgId = "MSGID:"
        let prefixPhoneId = "PHONEID:"

        let normalized = line.trimWhiteSpaces()

        if normalized == isReady {
            return .ready
        }

        if normalized == isRepeat {
            return .repeatCommand
        }

        if normalized.hasPrefix(prefixMsgId) {
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

        if normalized.hasPrefix(prefixPhoneId) {
            let regex = #"^PHONEID:(.+)$"#

            let groups = line.groups(for: regex)

            if groups.count == 0 {
                return .undefined
            }

            if groups[0].count != 2 {
                return .undefined
            }

            let parts = groups[0]
            let phoneId = parts[1].trimWhiteSpaces()
            return .phone(id: phoneId)
        }


        if normalized.hasPrefix(prefixError) {
            let text = line.dropFirst(prefixError.count)
            return .error(text: String(text).tripResponse())
        }

        if normalized.hasPrefix(prefixMessage) {
            let regex = #"^MSG\s+(\d+)\s+(.+)$"#

            let groups = line.groups(for: regex)

            if groups.count == 0 {
                return .undefined
            }

            if groups[0].count != 3 {
                return .undefined
            }

            let parts = groups[0]
            let rawMsgPart = parts[2].tripResponse()

            guard let msgData = Data(base64Encoded: rawMsgPart)
            else { return .undefined }

            guard let (text, from) = readProto(source: msgData)
            else { return .undefined }

            return .message(appId: Int(parts[1]) ?? 0, text: text, from: from)
        }

        if normalized.hasPrefix(prefixACK) {
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


    func readProto(source: Data) -> (text: String, from: String)? {
        guard let message = try? Ca_Pigscanfly_Proto_Message(serializedData: source)
        else { return nil }
        return (message.text, message.fromOrTo)
    }
}
