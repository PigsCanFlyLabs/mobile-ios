//
//  MessagesView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 02.03.2022.
//

import SwiftUI

struct MessagesView: View {

    @ObservedObject private var viewModel = DialogsViewModel.shared
    @ObservedObject private var viewModelMessages = MessagesViewModel.shared

    @State private var searchText = ""
    @State private var isPresentedAddScreen: Bool = false

    var visibleDialogs: [Dialog] {
        viewModel.openedDialogs.filter({
            searchText.isEmpty
                ? true
                : $0.contains(text: searchText)
        })
    }
    

    var body: some View {
        VStack {
            navBarView
            searchbarView
            dialogsView
        }
        .navigationBarHidden(true)
        .background(EmptyView().fullScreenCover(isPresented: $isPresentedAddScreen, onDismiss: {}, content: {
            AddContactView()
        }))
    }

    var dialogsView: some View {
        ScrollView {
            Button(action: {
                MessagesViewModel.shared.receivedMessage(text: "Hi test", from: "432423423")
            }, label: { Text("[Simulate received]") })

            LazyVStack {
                ForEach(visibleDialogs) { item in
                    DialogRow(dialog: item)
                }
            }
        }
        .padding(.horizontal, 24)
    }

    var navBarView: some View {
        HStack {
            Text("Messages")
                .font(Fonts.bold.size32)

            Spacer()

            Button(action: {
                isPresentedAddScreen.toggle()
            }) {
                Icons.plus
            }
            .buttonStyle(PlainButtonStyle())

        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
    }

    var searchbarView: some View {
        SearchBar(text: $searchText)
            .padding(.top, -30)
            .padding(.horizontal, 24)
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
