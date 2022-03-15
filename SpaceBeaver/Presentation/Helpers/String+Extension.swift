//
//  String+Extension.swift
//  KarmaCall
//
//  Created by Dmytro Kholodov on 27.05.2021.
//

import UIKit

extension Optional where Wrapped == String {
    var isValid: Bool {
        if let self = self, !self.isEmpty { return true }
        return false
    }
}

extension String {
    func tripWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    func removePlusIfNeeded() -> String {
        if self.starts(with: "+") {
            return String(self.dropFirst())
        }
        return self
    }

    func removeAnyNonDigit() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }

    func phoneFormatE164() -> String {
        let rawNumber = self.removeAnyNonDigit()
        return rawNumber
    }

    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        return isStringValid(regex)
    }

    func isValidPassword() -> Bool {
        return count >= 6
    }


    private func isStringValid(_ regex: NSRegularExpression) -> Bool {
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }

    /// mask example: `+X (XXX) XXX-XXXX`
    func format(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}
