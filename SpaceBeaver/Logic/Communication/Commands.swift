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
    /// Query the device ID, Returns deviceid.
    case deviceId

    /// the next two bytes are the application id the remainder of the message is a UTF-8 encoded string which will be relayed to the modem more or less directly as a $TD message. For clarity the client should not send another message until after the message is ackd with eather "MSGID: {id}" or "ERROR: ..."
    case message(appId: Int, text: String)


    var dataString: String {
        switch self {
        case .verifySetup:
            return "Q"
        case .deviceId:
            return "D"
        case let .message(appId, text):
            return "M\(appId)\(text)"
        }
    }

    var data: Data {
        dataString.data(using: .utf8) ?? Data()
    }
}




extension String {
    func tripResponse() -> String {
        
        return self.removeColumnIfNeeded().tripWhiteSpaces()
    }

    private func removeColumnIfNeeded() -> String {
        if self.starts(with: ":") {
            return String(self.dropFirst())
        }
        return self
    }
}

extension String {
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
