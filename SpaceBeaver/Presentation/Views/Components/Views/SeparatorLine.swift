//
//  SeparatorLine.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 09.03.2022.
//

import SwiftUI

struct SeparatorLine: View {
    var body: some View {
        Rectangle()
            .frame(height: 1).foregroundColor(Colors.colorGrey)
    }
}

struct SeparatorLine_Previews: PreviewProvider {
    static var previews: some View {
        SeparatorLine()
    }
}
