//
//  RoundedTextField.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 09.03.2022.
//

import SwiftUI

struct RoundedTextField: TextFieldStyle {

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 13)
            .background(Colors.colorGrey)
            .cornerRadius(12)
    }
}
