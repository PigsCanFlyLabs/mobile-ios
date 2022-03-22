//
//  Writer.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import Foundation

class CommandBuilder {

    func prepareQuery() -> (header: Data, body: Data) {
        let commandData = "Q".data(using: .utf8)!

        var value = UInt32(littleEndian: UInt32(commandData.count))
        let array = withUnsafeBytes(of: &value) { Array($0) }
        let data = Data(array)

        return (data, commandData)
    }

    func prepareSetProfile(profile: String) -> (header: Data, body: Data) {
        let commandData = "P\(profile)".data(using: .utf8)!

        var value = UInt32(littleEndian: UInt32(commandData.count))
        let array = withUnsafeBytes(of: &value) { Array($0) }
        let data = Data(array)

        return (data, commandData)
    }


    func prepareMessageLength(text: String, receipient: String) -> (header: Data, body: Data) {
        let messageData = prepareMessageCommand(text: text, to: receipient)

        var value = UInt32(littleEndian: UInt32(messageData.count))
        let array = withUnsafeBytes(of: &value) { Array($0) }
        let data = Data(array)

        return (data, messageData)
    }

    func prepareMessageCommand(text: String, to: String) -> Data {
        // M
        let commandPrefixData = "M".data(using: .utf8)!

        // AppId
        var valueApp = UInt16(littleEndian: UInt16(ProjEnvironment.appId))
        let arrayApp = withUnsafeBytes(of: &valueApp) { Array($0) }
        let dataApp = Data(arrayApp)

        // Message
        let protoBuf = makeProtoBuf(text: text, to: to)

        var combined = Data()
        combined.append(commandPrefixData)
        combined.append(dataApp)
        combined.append(protoBuf)
        return combined
    }

    func makeProtoBuf(text: String, to: String) -> Data {
        var message = Ca_Pigscanfly_Proto_Message()
        message.text = text
        message.fromOrTo = to
        message.protocol = .unknown

        return try! message.serializedData()
    }

    func makeProtoBufAsBase64(text: String, from: String) -> String {
        var message = Ca_Pigscanfly_Proto_Message()
        message.text = text
        message.fromOrTo = from
        message.protocol = .unknown

        let data = try! message.serializedData()

        return data.base64EncodedString()
    }
}
