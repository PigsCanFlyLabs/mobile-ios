//
//  SettingsView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 02.03.2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var viewModelSetup = SetupViewModel.shared
    @State private var isPresentedLogsScreen: Bool = false
    
    var body: some View {
        VStack {
            navBarView

            VStack(spacing: 24) {
                if viewModelSetup.connected != nil {
                    paramsView
                }
                blockedView
                privacyView
                helpView
                logsView
                actionView
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationBarHidden(true)
        .background(EmptyView().fullScreenCover(isPresented: $isPresentedLogsScreen, onDismiss: {}, content: {
            LogsView()
        }))
    }

    var navBarView: some View {
        HStack {
            Text("Settings")
                .font(Fonts.bold.size32)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 30)
    }


    private var paramsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let device = viewModelSetup.connected {
                VStack(alignment: .leading) {
                    Text("Device ID")
                        .font(Fonts.book.size14)
                    Text(device.name + " [" + device.deviceID + "]")
                        .font(Fonts.book.size18)
                        .foregroundColor(Colors.colorAccent)
                }
            }

//            VStack(alignment: .leading) {
//                Text("Your phone number")
//                    .font(Fonts.book.size14)
//                Text("884-184-5818")
//                    .font(Fonts.book.size18)
//                    .foregroundColor(Colors.colorAccent)
//            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Colors.colorGrey)
        .cornerRadius(10)
    }

    private var blockedView: some View {
        Button(action: {}) {
            Text("Blocked numbers")
                .font(Fonts.book.size18)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Colors.colorGrey)
                .cornerRadius(10)
        }
    }

    private var privacyView: some View {
        Button(action: {}) {
            Text("Privacy Policy")
                .font(Fonts.book.size18)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Colors.colorGrey)
                .cornerRadius(10)
        }
    }

    private var helpView: some View {
        Button(action: {}) {
            Text("Help")
                .font(Fonts.book.size18)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Colors.colorGrey)
                .cornerRadius(10)
        }
    }

    private var actionView: some View {
        let actionTitle = viewModelSetup.connected != nil
            ? "Disconnect device"
            : "Find device"

        return Button(action: connectAction) {
            Text(actionTitle)
                .font(Fonts.book.size18)
                .foregroundColor(Colors.colorAccent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Colors.colorGrey)
                .cornerRadius(10)
        }
    }

    private func connectAction() {
        if viewModelSetup.connected != nil {
            viewModelSetup.disconnectDevice()
        } else {
            viewModelSetup.findDevice()
        }
    }

    private var logsView: some View {
        Button(action: { isPresentedLogsScreen.toggle() }) {
            Text("Logs")
                .font(Fonts.book.size18)
                .foregroundColor(Color.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Colors.colorGrey)
                .cornerRadius(10)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
