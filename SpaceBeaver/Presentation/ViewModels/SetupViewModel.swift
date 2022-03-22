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

    @Published var deviceId: String? = nil


    private var cancellables = Set<AnyCancellable>()
    init() {
        scanner.$isConnected.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .scanning:
                ()
            case .connected:
                ()
            case .unconnected:
                self.flow = .noConnectionWithDevice
            }
        }
        .store(in: &cancellables)

        scanner.$profileId.sink { [weak self] phoneId in
            guard let phoneid = phoneId else { return }
            self?.connected = Device(deviceID: phoneid)
            self?.flow = .finished
        }
        .store(in: &cancellables)

        scanner.$registerDeviceId.sink { [weak self] deviceId in
            guard let deviceId = deviceId else { return }
            self?.flow = .registerDevice
            self?.deviceId = deviceId
        }
        .store(in: &cancellables)
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
