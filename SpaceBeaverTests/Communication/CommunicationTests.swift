//
//  CommunicationTests.swift
//  SpaceBeaverTests
//
//  Created by Dmytro Kholodov on 12.04.2022.
//

import XCTest
@testable import SpaceBeaver


class CommunicationTests: XCTestCase {

    func testReceivedData() throws {
        var sentData = Data()
        let (header, body) = CommandBuilder().prepareSetProfile(profile: "TEST")
        sentData.append(header)
        sentData.append(body)

        let sut = SpaceBeaverManager()
        sut.handleReceivedString = { line in
            XCTAssertEqual(line, "PTEST")
        }
        sut.received(data: sentData)
    }

    func testReceivedData2() throws {
        var sentData = Data()
        let (header, body) = CommandBuilder().prepareSetProfile(profile: "TEST")
        sentData.append(header)
        var extraBody = body
        extraBody.append(contentsOf: [0x033, 0x00, 0x00, 0x00, 0x033, 0x00, 0x00, 0x00, 0x033, 0x00, 0x00, 0x00])
        sentData.append(extraBody)

        let sut = SpaceBeaverManager()
        sut.handleReceivedString = { line in
            XCTAssertEqual(line, "PTEST")
        }
        sut.received(data: sentData)
    }

    func testReceivedData3() throws {
        var received = Data()
        received.append(contentsOf: [0x0D, 0x00, 0x00, 0x00])
        received.append(contentsOf: [0x50, 0x48, 0x4F, 0x4E, 0x45, 0x49, 0x44, 0x3A, 0x20, 0x00, 0x34, 0x00, 0x35])

        // PHONT~C¢
        let sut = SpaceBeaverManager()
        sut.received(data: received)
    }

}

