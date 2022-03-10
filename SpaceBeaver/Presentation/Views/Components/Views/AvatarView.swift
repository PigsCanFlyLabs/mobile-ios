//
//  AvatarView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 04.03.2022.
//

import SwiftUI

struct AvatarView: View {
    let contact: Contact

    var body: some View {
        Circle()
            .foregroundColor(Color.blue)
            .frame(width: 56, height: 56)
            .overlay(
                Text(contact.title.prefix(1).uppercased())
                    .font(Fonts.medium.size32)
                    .foregroundColor(Color.white)
            )
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(contact: Contact.dummy1)
    }
}
