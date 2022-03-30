//
//  FailedToConnectView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI

struct FailedToConnectView: View {
    @ObservedObject private var viewModelSetup = SetupViewModel.shared
    @State private var isPresentedLogsScreen: Bool = false
    
    var body: some View {
        VStack {
            Spacer()

            header

            Spacer()

            ConnectionIllustration(kind: .failed)
            

            Spacer()

            instructions

            Spacer()

            linkTrouble
            Button {
                isPresentedLogsScreen.toggle()
            } label: {
                Text("[Show logs]")
            }
        }
        .background(EmptyView().fullScreenCover(isPresented: $isPresentedLogsScreen, onDismiss: {}, content: {
            LogsView()
        }))
    }

    private var header: some View {
        Group {
            Text("Welcome, ")
                .foregroundColor(Colors.colorAccent)
                .font(Fonts.bold.size32)

            Text("Space Beaver")
                .foregroundColor(Colors.colorAccent)
                .font(Fonts.bold.size50)
        }
    }

    private var instructions: some View {
        Group {
            Text("Failed to connect")
                .font(Fonts.bold.size24)
            Text("Press and hold the button on your device")
                .font(Fonts.book.size16)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 50)
    }

    private var linkTrouble: some View {
        Link("Having trouble? Get help", destination: URL(string: "https://google.com")!)
            .foregroundColor(Colors.colorGreyText)
            .font(Fonts.book.size16)
    }
}

struct FailedToConnectView_Previews: PreviewProvider {
    static var previews: some View {
        FailedToConnectView()
    }
}
