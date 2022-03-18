//
//  String+Ext.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 16.03.2022.
//

import Foundation

extension String {
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension String {
    func tripResponse() -> String {

        return self.removeColumnIfNeeded().trimWhiteSpaces()
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
