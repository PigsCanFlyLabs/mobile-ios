//
//  SetupViewModel.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 02.03.2022.
//

import Foundation
import Combine
import SwiftUI

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
                EventsLogger.shared.log(level: .debug, message: "[FLOW] scanner.isConnected is connected = scanning")
            case .connected:
                EventsLogger.shared.log(level: .debug, message: "[FLOW] scanner.isConnected is connected = connected")
            case .unconnected:
                self.flow = .noConnectionWithDevice
                EventsLogger.shared.log(level: .debug, message: "[FLOW] scanner.isConnected is connected = unconnected")
                EventsLogger.shared.log(level: .debug, message: "[FLOW] status = no connection with device")
            }
        }
        .store(in: &cancellables)

        scanner.$profileId.sink { [weak self] phoneId in
            EventsLogger.shared.log(level: .debug, message: "[FLOW] scanner.profileId \(phoneId)")
            EventsLogger.shared.log(level: .debug, message: "[FLOW] scanner.peripheral.name \(self?.scanner.peripheral?.name)")
            guard let phoneid = phoneId, let name = self?.scanner.peripheral?.name else { return }
            self?.connected = Device(deviceID: phoneid, name: name)
            self?.flow = .finished
            EventsLogger.shared.log(level: .debug, message: "[FLOW] status = finished")
        }
        .store(in: &cancellables)

        scanner.$registerDeviceId.sink { [weak self] deviceId in
            EventsLogger.shared.log(level: .debug, message: "[FLOW] scanner.registerDeviceId \(deviceId)")
            guard let deviceId = deviceId else { return }
            self?.flow = .registerDevice
            self?.deviceId = deviceId
            EventsLogger.shared.log(level: .debug, message: "[FLOW] status = registerDevice")
        }
        .store(in: &cancellables)
    }

    @ObservedObject var scanner = SpaceBeaverManager.shared

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
