//
//  ContactView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 08.03.2022.
//

import SwiftUI

struct ContactView: View {
    let contact: Contact

    @State var blocked: Bool = false

    init(contact: Contact) {
        self.contact = contact
        self._blocked = State(initialValue: contact.blocked)
    }

    @ObservedObject private var viewModelContacts = ContactsViewModel.shared
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.clear

            closeView

            VStack(spacing: 24) {
                headerView
                contactsView
                actionView

                Spacer()
            }
            .padding(.horizontal)
        }
    }

    private var closeView: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Button(action: {
                dismiss()
            }) {
                Text("Done")
                    .font(Fonts.medium.size16)
                    .padding(.horizontal)
            }
        }
    }

    private var headerView: some View {
        HStack {
            VStack(spacing: 6) {
                AvatarView(contact: contact)
                Text(contact.title)
                    .font(Fonts.bold.size24)
            }
        }
        .padding(.vertical, 10)
    }

    private var contactsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let phone = contact.phoneNumber {
                VStack(alignment: .leading) {
                    Text("Phone number")
                        .font(Fonts.book.size14)
                    Text(phone)
                        .font(Fonts.book.size18)
                        .foregroundColor(Color.accentColor)
                }
            }

            if let email = contact.email {
                VStack(alignment: .leading) {
                    Text("Email")
                        .font(Fonts.book.size14)
                    Text(email)
                        .font(Fonts.book.size18)
                        .foregroundColor(Color.accentColor)
                }
            }

            VStack(alignment: .leading) {
                Text("Ringtone")
                    .font(Fonts.book.size14)
                Text("Sound: Forest")
                    .font(Fonts.book.size18)
                    .foregroundColor(Color.accentColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Colors.colorGrey)
        .cornerRadius(10)
    }

    private var actionView: some View {
        Button(action: {
            blocked.toggle()
            viewModelContacts.toggleBlockContact(contact: contact)
        }) {
            Text(blocked ? "Unblock this contact" : "Block this contact")
                .font(Fonts.book.size18)
                .foregroundColor(blocked ? Color.black : Color.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Colors.colorGrey)
                .cornerRadius(10)
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(contact: Contact.dummy3)
    }
}
