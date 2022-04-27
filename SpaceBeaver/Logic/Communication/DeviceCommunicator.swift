//
//  DeviceCommunicator.swift
//  SpaceBeaver
//
//  Created by Dmytro Kholodov on 16.03.2022.
//

import Foundation
import Combine

protocol SpaceBeaverWritable {
    func writeToDevice(data: Data)
}

protocol SpaceBeaverReadable {
    func readFromDevice(line: String)
}

class DeviceCommunicator: SpaceBeaverReadable {

    init(device: SpaceBeaverWritable, logger: EventsLogger) {
        self.device = device
        self.logger = logger
    }

    let device: SpaceBeaverWritable
    let logger: EventsLogger

    var performedCommand: BaseCommand? = nil
    var pendingCommands: [BaseCommand] = []

    enum CommunicatorState {
        case ready
        case busy
    }

    var communication: CommunicatorState = .busy

    func send(command: BaseCommand) {
        logger.log(level: .debug, message: "[MESSAGES] pending command \(command.description)")
        let autostart = pendingCommands.isEmpty
        pendingCommands.insert(command, at: 0)
        if autostart { performPending() }
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
        logger.log(level: .verbose, message: "[MESSAGES] send command \(command.description)")
    }

    func readFromDevice(line: String) {
        logger.log(level: .verbose, message: "[MESSAGES] read \(line)")

        let recognized = ResponseReader().parse(line: line)

        switch recognized {
        case let .message(_, text, from):
            logger.log(level: .verbose, message: "[MESSAGES] recognized message")

            MessagesViewModel.shared.receivedMessage(text: text, from: from)
        case .msgSent(let messageId):
            logger.log(level: .verbose, message: "[MESSAGES] recognized message sent")
            performPending()
        case .ack(let messageId):
            logger.log(level: .verbose, message: "[MESSAGES] recognized ack")
            break
        case .error(let text):
            logger.log(level: .verbose, message: "[MESSAGES] recognized error")
            if performedCommand is CommandMessage {
                // do smth
            } else  if performedCommand is QueryDevice {

                if text.contains("not configured") {
                    let deviceId = text.replacingOccurrences(of: "not configured", with: "").trimWhiteSpaces()
                    SpaceBeaverManager.shared.profileId = nil
                    SpaceBeaverManager.shared.registerDeviceId = deviceId
                    fetchRemoteProfile(deviceId: deviceId) { [weak self] profileId in
                        if let profile = profileId {
                            let setProfile = SetProfile(profileId: profile)
                            self?.send(command: setProfile)
                            SpaceBeaverManager.shared.profileId = profile
                        }
                    }

                }
                SpaceBeaverManager.shared.profileId = nil
            }
            performPending()
        case .ready:
            logger.log(level: .verbose, message: "[MESSAGES] recognized ready")
            communication = .ready
            performPending()
        case .repeatCommand:
            logger.log(level: .verbose, message: "[MESSAGES] recognized repeat")
            communication = .ready
            resendPerformedCommand()
        case .phone(let id):
            logger.log(level: .verbose, message: "[MESSAGES] recognized phone")
            SpaceBeaverManager.shared.profileId = id

            performPending()
        case .undefined:
            break
        }
    }

    private func fetchRemoteProfile(deviceId: String, completion: @escaping (String?) -> Void ) {
        guard let serviceUrl = URL(string: "http://api.spacebeaver.com/device_lookup")
        else { return }

        logger.log(level: .verbose, message: "[MESSAGES] fetch from http://api.spacebeaver.com/device_lookup ")

        let parameterDictionary = ["device_id" : deviceId]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
          guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
              return
          }
          request.httpBody = httpBody

          let session = URLSession.shared
          session.dataTask(with: request) { [weak self] (data, response, error) in
              if let data = data {
                  let profile = String(decoding: data, as: UTF8.self)
                  self?.logger.log(level: .verbose, message: "[MESSAGES] fetched profile \(profile)")
                  completion(profile)
              } else {
                  completion(nil)
              }
              if let error = error {
                  self?.logger.log(level: .error, message: "[MESSAGES] fetched profile \(error.localizedDescription)")
              }

          }.resume()
    }
    
}
