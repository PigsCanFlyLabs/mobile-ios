//
//  DialogView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI


struct DialogView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel = MessagesViewModel.shared

    @State private var message: String = ""
    @State private var isPresentedContactScreen: Bool = false

    let dialog: Dialog

    var body: some View {
        VStack {
            navBarView
            messagesView
                .refreshable {
                    viewModel.loadPreviousMessages()
                 }
            inputView
        }
        .navigationBarHidden(true)
        
        .background(EmptyView().fullScreenCover(isPresented: $isPresentedContactScreen, onDismiss: {}, content: {
            ContactView(contact: dialog.contact)
        }))

        .task {
            viewModel.openDialog(dialog)
        }
        .onDisappear {
            viewModel.closeDialog()
        }
    }

    private var messagesView: some View {
        ScrollViewReader { proxy in
            List(viewModel.messages) { message in
                messageRow(message)
                    .id(message.id)
                    .padding()
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .onChange(of: viewModel.messages) { _ in
                if viewModel.scrollToLastMessage, let lastId = viewModel.messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId)
                    }
                }
            }
        }
    }

    private func messageRow(_ message: Message) -> some View {
        Group {
            switch message.kind {
            case .outgoing:
                HStack {
                    Spacer()
                    Text(message.text)
                        .font(Fonts.book.size16)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Colors.colorAccent)
                        .cornerRadius(24)
                        .padding(.leading, 40)
                }
                .frame(maxWidth: .infinity)
            case .incoming:
                HStack {
                    Text(message.text)
                        .font(Fonts.book.size16)
                        .padding()
                        .background(Colors.colorGrey)
                        .cornerRadius(24)
                        .padding(.trailing, 40)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var inputView: some View {
        TextField("Message", text: $message)
            .textFieldStyle(RoundedTextField())
            .padding(.horizontal)
            .padding(.vertical)
            .onSubmit {
                viewModel.sendMessage(text: message, in: dialog)
                message = ""
            }
    }

    private var navBarView: some View {
        ZStack {
            HStack {
                Button(action: {
                    isPresentedContactScreen.toggle()
                }) {
                    VStack(spacing: 6) {
                        AvatarView(contact: dialog.contact)
                        Text(dialog.contact.title)
                            .font(Fonts.medium.size16)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 10)

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: { Icons.arrowLeft })

                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .background {
            VStack {
                Spacer()
                SeparatorLine()
            }
        }
    }
}

struct DialogView_Previews: PreviewProvider {
    static var previews: some View {
        DialogView(dialog: Dialog.dummy3)
    }
}
