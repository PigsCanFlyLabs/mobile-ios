//
//  SetupViewModel.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 02.03.2022.
//

import Foundation
import Combine

class SetupViewModel: ObservableObject {

    enum Flow {
        case waitingForDevice
        case waitingForConnection
        case finished
    }

    static let shared = SetupViewModel()

    private var cancellable: AnyCancellable?

    init() {
        cancellable = scanner.$isConnected.sink { [weak self] value in
            guard let self = self else { return }
            if value {
                self.flow = .waitingForConnection
                let deviceName = self.scanner.peripheral?.peripheral.name ?? "?"
                self.connected = Device(deviceID: deviceName)
            }
        }
    }

    let scanner = SpaceBeaverManager()

    @Published private(set) var flow: Flow = .waitingForDevice
    @Published private(set) var connected: Device?

    var isSetupFinished: Bool { flow == .finished }

    func connectDevice() {
        flow = .waitingForConnection
        connected = Device.dummy
    }

    func disconnectDevice() {
        connected = nil
    }

    func finishSetup() {
        flow = .finished
    }

    func findDevice() {
        flow = .waitingForDevice
    }

}
