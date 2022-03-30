//
//  SetupConnectView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 03.03.2022.
//

import SwiftUI

struct SetupConnectView: View {
    @ObservedObject private var viewModelSetup = SetupViewModel.shared
    @State private var isPresentedLogsScreen: Bool = false

    var code: String { viewModelSetup.deviceId ?? "<MISSING>" }

    var body: some View {
        VStack {
            Spacer()

            header

            Spacer()

            ConnectionIllustration(kind: .success)

            Spacer()

            instructions

            Spacer()

            Button(action: {
                viewModelSetup.finishSetup()
            }) {
                HStack {
                    Text("Done")
                        .fontWeight(.medium)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(Colors.colorAccent)
                .cornerRadius(40)
            }
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
            Text("Connected")
                .font(.system(size: 24))

            Text("Go to [www.spacebeaver.com/connect](https://www.spacebeaver.com/connect) and type in \(code) to select your plan")
                .multilineTextAlignment(.center)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 50)
    }
}

struct SetupConnectView_Previews: PreviewProvider {
    static var previews: some View {
        SetupConnectView()
    }
}
