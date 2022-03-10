//
//  AddContactView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 09.03.2022.
//

import SwiftUI

struct AddContactView: View {
    @State private var searchText = ""
    @State private var message: String = ""

    @Environment(\.dismiss) private var dismiss

    @ObservedObject private var viewModelContacts = ContactsViewModel.shared
    @ObservedObject private var viewModelMessages = MessagesViewModel.shared

    var body: some View {
        VStack {
            navBarView
            searchbarView
            contacts
            inputView
        }
        .navigationBarHidden(true)
        .task {
            viewModelContacts.verifyPermissions()
        }
        .onChange(of: searchText) { filter in
            viewModelContacts.findContacts(by: filter)
        }
    }

    private var searchbarView: some View {
        SearchContactView(text: $searchText)
            .padding(.horizontal, 24)
            .disabled(!viewModelContacts.accessGranted)
    }

    private var contacts: some View {
        List(viewModelContacts.suggested) { contact in
            Button(action: {
                viewModelContacts.selected = contact
                searchText = contact.title
            }) {
                VStack(alignment: .leading) {
                    Text(contact.title)
                    Text(contact.phoneNumber ?? "")
                    SeparatorLine()
                }
                .font(Fonts.book.size18)
                .foregroundColor(Colors.colorAccent)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 25)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    private var inputView: some View {
        TextField("Message", text: $message)
            .textFieldStyle(RoundedTextField())
            .padding(.horizontal)
            .padding(.vertical)
            .disabled(viewModelContacts.selected == nil || !viewModelContacts.accessGranted)
            .onSubmit {
                if let contact = viewModelContacts.selected {
                    viewModelMessages.sendMessage(text: message, to: contact)
                    dismiss()
                }
            }
    }

    private var navBarView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModelContacts.clearContacts()
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .font(Fonts.medium.size16)
                })
            }
            .padding(.horizontal, 32)
            Text("New Message")
                .font(Fonts.bold.size24)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactView()
    }
}
