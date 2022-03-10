//
//  SetupSatelliteView.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 01.03.2022.
//

import SwiftUI

struct SetupSatelliteView: View {

    @ObservedObject private var viewModelSetup = SetupViewModel.shared

    var body: some View {
        VStack {
            Spacer()

            header

            Spacer()

            Images.satelliteOrbits
                .padding(.bottom, 50)

            Spacer()

            instructions

            Spacer()

            linkTrouble

            Button {
                viewModelSetup.connectDevice()
            } label: {
                Text("[Simulate device]")
            }

        }
    }

    private var header: some View {
        Group {
            Text("Welcome, ")
                .foregroundColor(Colors.colorAccent)
                .font(.system(size: 32))

            Text("Space Beaver")
                .foregroundColor(Colors.colorAccent)
                .font(.system(size: 50))
        }
    }

    private var instructions: some View {
        Group {
            Text("Get Started")
                .font(.system(size: 24))
            Text("Press and hold the button on your device")
                .font(.system(size: 16))
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 100)
    }

    private var linkTrouble: some View {
        Link("Having trouble? Get help", destination: URL(string: "https://google.com")!)
            .foregroundColor(Colors.colorGreyText)
            .font(.system(size: 16))
    }
}

struct SetupSatelliteView_Previews: PreviewProvider {
    static var previews: some View {
        SetupSatelliteView()
    }
}
