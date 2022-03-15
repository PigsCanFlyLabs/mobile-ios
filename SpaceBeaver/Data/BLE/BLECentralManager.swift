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
    let logger = EventsLogger()

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
    }

    func connect(peripheral: Peripheral) {
//        scanner.stopScanning()
        self.peripheral = peripheral
        btManager.connectPeripheral(peripheral: peripheral.peripheral)
    }

}


extension SpaceBeaverManager: PeripheralScannerDelegate {
    func statusChanges(_ status: PeripheralScanner.Status) {
        print(status)
//        if case .connecting(let p) = status {
//           // delegate?.requestConnection(to: p)
//        }
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
    func requestedConnect(peripheral: CBPeripheral) {

    }

    func didConnectPeripheral(deviceName aName : String?) {
        print("didConnectPeripheral \(aName)")
        isConnected = .connected
    }

    func didDisconnectPeripheral() {
        print("didDisconnectPeripheral")
        isConnected = .unconnected
    }

    func peripheralReady() {}

    func peripheralNotSupported() {
        print("peripheralNotSupported")
    }
}
