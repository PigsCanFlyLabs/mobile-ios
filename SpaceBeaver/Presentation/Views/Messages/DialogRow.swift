//
//  DialogRow.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI

struct DialogRow: View {
    let dialog: Dialog

    var body: some View {
        NavigationLink(destination: DialogView(dialog: dialog)) {
            content
                .padding(.vertical, 15)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
    }

    var content: some View {
        HStack(spacing: 16) {
            AvatarView(contact: dialog.contact)
            VStack(spacing: 4) {
                HStack {
                    Text(dialog.contact.title)
                        .font(Fonts.medium.size18)

                    Spacer()
                    Text(dialog.lastUpdated, style: .time)
                        .font(Fonts.book.size16)
                        .foregroundColor(Colors.colorGreyText)
                }
                HStack {
                    Text(dialog.message)
                        .font(Fonts.book.size16)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
    }
}

struct DialogRow_Previews: PreviewProvider {
    static var previews: some View {
        DialogRow(dialog: Dialog.dummy1)
    }
}
