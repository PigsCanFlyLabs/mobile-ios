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

    static let deviceIdentifier = UUID(uuidString: "BB539D7A-E05B-6F10-AE77-B3E6A808DB6F")
    static let devicePrefix = "SpaceBeaver"

    enum Connectivity {
        case scanning
        case connected
        case unconnected
    }

    @Published var isConnected: Connectivity = .scanning

    @Published var profileId: String?
    @Published var registerDeviceId: String?

    @Published var hasToFetchDeviceId: Bool = false

    let btManager = BluetoothManager()
    var communicator: DeviceCommunicator? = nil
    @Published var logger = EventsLogger()

    let scanner: PeripheralScanner
    var peripheral: Peripheral? = nil

    let MAIN_SERVICE1 = CBUUID(string: ServiceIdentifiers.uartServiceUUIDString)

    var currentPacketSize: Int = -1
    var currentPacketBuffer: Data? = nil
    var handleReceivedString: ((String) -> Void)?

    init() {
        scanner = PeripheralScanner(services: [])
        scanner.scannerDelegate = self
        btManager.delegate = self
        btManager.logger = logger
        communicator = DeviceCommunicator(device: self)
    }

    func connect(peripheral: Peripheral) {
        if self.peripheral != nil { return }
        self.peripheral = peripheral
        btManager.connectPeripheral(peripheral: peripheral.peripheral)
    }

    func sendMessage(to: String, text: String) {
        let message = CommandMessage(to: to, text: text)
        communicator?.send(command: message)
    }

    func sendQueryProfile() {
        let query = QueryDevice()
        communicator?.send(command: query)
    }

    func sendSetProfile() {
        guard let id = profileId else { return }
        let profile = SetProfile(profileId: id)
        communicator?.send(command: profile)
    }
}


extension SpaceBeaverManager: PeripheralScannerDelegate {
    func statusChanges(_ status: PeripheralScanner.Status) {
        logger.log(level: .verbose, message: "[Peripheral] status changes state to: \(status)")
    }

    func newPeripherals(_ peripherals: [Peripheral], willBeAddedTo existing: [Peripheral]) {
//        logger.log(level: .verbose, message: "[Peripheral] newPeripherals found")
    }

    func peripherals(_ peripherals: [Peripheral], addedTo old: [Peripheral]) {
        peripherals.forEach { p in
            logger.log(level: .verbose, message: "[Peripheral] found \(p.peripheral.identifier) ...")
        }

        if let peripherlByUID = peripherals.first(where: { p in
            return p.hasNamePrefix(value: SpaceBeaverManager.devicePrefix)
        }) {
            logger.log(level: .verbose, message: "[Peripheral] trying to connect to  peripheral \(peripherlByUID.name) ...")
            logger.log(level: .verbose, message: "[Peripheral] trying to connect to  peripheral \(peripherlByUID.peripheral.identifier) ...")
            connect(peripheral: peripherlByUID)
        }
    }
}

extension SpaceBeaverManager: BluetoothManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            scanner.startScanning()
        default:
            ()
        }
    }

    func received(data: Data) {
        if currentPacketSize <= 0 {
            // receiving a new packet
            assert(data.count > 3, "Packet size is less then 4 bytes")

            // Get message length
            let header = Data(data.prefix(4))

            let length = header.uint32
            logger.log(level: .verbose, message: "[Peripheral] receiving new packet length [\(length)]")

            currentPacketSize = Int(length)
            currentPacketBuffer = Data()

            // Remaining in this packet
            let remainding = data.dropFirst(4)
            received(data: remainding)

        } else {
            // Continue receiving data
            if currentPacketSize >= data.count {
                currentPacketSize -= data.count
                currentPacketBuffer?.append(contentsOf: data)

                if currentPacketSize <= 0 {
                    if let bytesReceived = currentPacketBuffer, let validUTF8String = String(data: bytesReceived, encoding: .utf8) {
                        received(string: validUTF8String)
                    }
                    // Finished
                    currentPacketBuffer = nil
                }
            } else {
                let partCount = currentPacketSize
                let partData = Data(data.prefix(currentPacketSize))
                currentPacketSize = 0
                currentPacketBuffer?.append(contentsOf: partData)

                if currentPacketSize <= 0 {
                    if let bytesReceived = currentPacketBuffer, let validUTF8String = String(data: bytesReceived, encoding: .utf8) {
                        received(string: validUTF8String)
                    }
                    // Finished
                    currentPacketBuffer = nil
                }

                // Remaining data
                let remainding = data.dropFirst(partCount)
                received(data: remainding)
            }
        }
    }

    func received(string: String) {
        if let handler = handleReceivedString {
            handler(string)
            return
        }
        logger.log(level: .verbose, message: "[Peripheral] received message: \(string)")
        communicator?.readFromDevice(line: string)
    }

    func requestedConnect(peripheral: CBPeripheral) {
        logger.log(level: .verbose, message: "[Peripheral] request connect \(peripheral.identifier)")
    }

    func didConnectPeripheral(deviceName aName : String?) {
        logger.log(level: .verbose, message: "[Peripheral] did connect peripheral : \(aName ?? "Undefined")")
        isConnected = .connected
        sendQueryProfile()
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

extension Data {
    func elements <T> () -> [T] {
        return withUnsafeBytes {
            Array(UnsafeBufferPointer<T>(start: $0, count: count / MemoryLayout<T>.size))
        }
    }
}

extension Data {
    var uint32:UInt32 {
        var data = self
        return UInt32(littleEndian: data.withUnsafeMutableBytes { (ptr: UnsafeMutablePointer<UInt32>) in ptr.pointee })
    }
}
