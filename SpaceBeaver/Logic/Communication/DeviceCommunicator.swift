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
            communication = .ready
            performPending()
        case .repeatCommand:
            communication = .ready
            resendPerformedCommand()
        case .phone(let id):
            if performedCommand is QueryDevice {
                SpaceBeaverManager.shared.profileId = id
            }
            performPending()
        case .undefined:
            break
        }
    }

    private func fetchRemoteProfile(deviceId: String, completion: @escaping (String?) -> Void ) {
        guard let serviceUrl = URL(string: "http://api.spacebeaver.com/device_lookup")
        else { return }

        let parameterDictionary = ["device_id" : deviceId]
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
          guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
              return
          }
          request.httpBody = httpBody

          let session = URLSession.shared
          session.dataTask(with: request) { (data, response, error) in
              if let data = data {
                  let profile = String(decoding: data, as: UTF8.self)
                  completion(profile)
              } else {
                  completion(nil)
              }
          }.resume()
    }
    
}
