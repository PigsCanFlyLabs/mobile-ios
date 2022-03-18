//
//  BLECentralManager.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 05.03.2022.
//

import Foundation
import CoreBluetooth.CBPeripheral

class SpaceBeaverManager: ObservableObject {
    static let shared = SpaceBeaverManager()

    enum Connectivity {
        case scanning
        case connected
        case unconnected
    }

    @Published var isConnected: Connectivity = .scanning

    let btManager = BluetoothManager()
    var communicator: DeviceCommunicator? = nil
    @Published var logger = EventsLogger()

    let scanner: PeripheralScanner
    var peripheral: Peripheral? = nil

    //let MAIN_SERVICE2 = CBUUID(string: "7434FFFF-6D57-6854-6551-624D2B482845")

    let MAIN_SERVICE1 = CBUUID(string: ServiceIdentifiers.uartServiceUUIDString)

    init() {
        scanner = PeripheralScanner(services: [MAIN_SERVICE1])
        scanner.scannerDelegate = self
        btManager.delegate = self
        btManager.logger = logger
        scanner.startScanning()
        communicator = DeviceCommunicator(device: self)
    }

    func connect(peripheral: Peripheral) {
        self.peripheral = peripheral
        btManager.connectPeripheral(peripheral: peripheral.peripheral)
    }

}


extension SpaceBeaverManager: PeripheralScannerDelegate {
    func statusChanges(_ status: PeripheralScanner.Status) {
        logger.log(level: .verbose, message: "[Peripheral] status changes state to: \(status)")
    }

    func newPeripherals(_ peripherals: [Peripheral], willBeAddedTo existing: [Peripheral]) {

    }

    func peripherals(_ peripherals: [Peripheral], addedTo old: [Peripheral]) {
        if let autoconnected = peripherals.first {
            connect(peripheral: autoconnected)
        }
    }
}

extension SpaceBeaverManager: BluetoothManagerDelegate {
    func received(string: String) {
        communicator?.readFromDevice(line: string)
    }

    func requestedConnect(peripheral: CBPeripheral) {
        logger.log(level: .verbose, message: "[Peripheral] request connect \(peripheral.identifier)")
    }

    func didConnectPeripheral(deviceName aName : String?) {
        logger.log(level: .verbose, message: "[Peripheral] did connect peripheral : \(aName ?? "Undefined")")
        isConnected = .connected
    }

    func didDisconnectPeripheral() {
        logger.log(level: .verbose, message: "[Peripheral] disconnectUndefined")
        isConnected = .unconnected
    }

    func peripheralReady() {
        logger.log(level: .verbose, message: "[Peripheral] ready")
    }

    func peripheralNotSupported() {
        logger.log(level: .verbose, message: "[Peripheral] not supported")
    }
}

extension SpaceBeaverManager: SpaceBeaverWritable {
    func writeToDevice(data: Data) {
        btManager.send(data: data)
    }
}
