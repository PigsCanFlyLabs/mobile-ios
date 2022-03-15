//
//  Fonts.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI

enum Fonts: String, RawRepresentable {
    case bold = "CircularStd-Bold"
    case medium = "CircularStd-Medium"
    case black = "CircularStd-Black"
    case book = "CircularStd-Book"
}

extension Fonts {
    var size9: Font { Font.custom(self.rawValue, size: 10) }
    var size10: Font { Font.custom(self.rawValue, size: 10) }
    var size12: Font { Font.custom(self.rawValue, size: 12) }
    var size14: Font { Font.custom(self.rawValue, size: 14) }
    var size15: Font { Font.custom(self.rawValue, size: 15) }
    var size16: Font { Font.custom(self.rawValue, size: 16) }
    var size17: Font { Font.custom(self.rawValue, size: 17) }
    var size18: Font { Font.custom(self.rawValue, size: 18) }
    var size19: Font { Font.custom(self.rawValue, size: 19) }
    var size20: Font { Font.custom(self.rawValue, size: 20) }
    var size21: Font { Font.custom(self.rawValue, size: 21) }
    var size22: Font { Font.custom(self.rawValue, size: 22) }
    var size23: Font { Font.custom(self.rawValue, size: 23) }
    var size24: Font { Font.custom(self.rawValue, size: 24) }
    var size32: Font { Font.custom(self.rawValue, size: 32) }
    var size50: Font { Font.custom(self.rawValue, size: 50) }
}
