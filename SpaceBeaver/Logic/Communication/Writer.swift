//
//  Writer.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import Foundation

class Writer {

    func prepareMessageLength(appId: Int16, text: String) -> Data {
        let messageData = prepareMessageCommand(appId: appId, text: text)

        var value = UInt32(littleEndian: UInt32(messageData.count))
        let array = withUnsafeBytes(of: &value) { Array($0) }
        let data = Data(array)

        dump(data)
        return data
    }

    func prepareMessageCommand(appId: Int16, text: String) -> Data {
        // M
        let commandPrefixData = "M".data(using: .utf8)!

        // AppId
        var valueApp = UInt16(littleEndian: UInt16(appId))
        let arrayApp = withUnsafeBytes(of: &valueApp) { Array($0) }
        let dataApp = Data(arrayApp)

        // Message
        let textData = text.data(using: .utf8)!

        var combined = Data()
        combined.append(commandPrefixData)
        combined.append(dataApp)
        combined.append(textData)
        return combined
    }
}
