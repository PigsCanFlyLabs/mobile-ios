//
//  DeviceCommunicator.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 16.03.2022.
//

import Foundation

protocol SpaceBeaverWritable {
    func writeToDevice(data: Data)
}

protocol SpaceBeaverReadable {
    func readFromDevice(line: String)
}

class DeviceCommunicator: SpaceBeaverReadable {
    init(device: SpaceBeaverWritable) {
        self.device = device
    }

    let device: SpaceBeaverWritable

    var performedCommand: BaseCommand? = nil
    var pendingCommands: [BaseCommand] = []

    enum CommunicatorState {
        case ready
        case busy
    }

    var communication: CommunicatorState = .busy

    func send(command: BaseCommand) {
        pendingCommands.insert(command, at: 0)
    }

    func resendPerformedCommand() {
        guard let command = performedCommand
        else { return }

        communication = .busy
        performedCommand = command

        device.writeToDevice(data: command.header)
        device.writeToDevice(data: command.body)
    }

    func performPending() {
        guard let command = pendingCommands.popLast()
        else { return }

        communication = .busy
        performedCommand = command

        device.writeToDevice(data: command.header)
        device.writeToDevice(data: command.body)
    }

    func readFromDevice(line: String) {
        let recognized = ResponseReader().parse(line: line)

        switch recognized {
        case let .message(_, text, from):
            MessagesViewModel.shared.receivedMessage(text: text, from: from)
        case .msgSent(let messageId):
            performPending()
        case .ack(let messageId):
            break
        case .error(let text):
            if performedCommand is CommandMessage {
                // do smth
            }
            performPending()
        case .ready:
            communication = .ready
            performPending()
        case .repeatCommand:
            communication = .ready
            resendPerformedCommand()
        case .phone(let id):
            break
        case .undefined:
            break
        }
    }
    
}
