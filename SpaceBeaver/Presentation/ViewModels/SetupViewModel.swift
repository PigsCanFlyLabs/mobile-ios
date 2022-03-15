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
        case noConnectionWithDevice
        case registerDevice
        case finished
    }

    static let shared = SetupViewModel()

    private var cancellable: AnyCancellable?

    init() {
        cancellable = scanner.$isConnected.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .scanning:
                ()
            case .connected:
                self.flow = .registerDevice
                let deviceName = self.scanner.peripheral?.peripheral.name ?? "?"
                self.connected = Device(deviceID: deviceName)
            case .unconnected:
                self.flow = .noConnectionWithDevice
            }
        }
    }

    let scanner = SpaceBeaverManager()

    @Published private(set) var flow: Flow = .waitingForDevice
    @Published private(set) var connected: Device?

    var isSetupFinished: Bool { flow == .finished }

    func connectDevice() {
        flow = .registerDevice
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
