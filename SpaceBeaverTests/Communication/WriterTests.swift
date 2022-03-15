//
//  SendToDeviceTests.swift
//  SpaceBeaverTests
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import XCTest
@testable import SpaceBeaver

class SendToDeviceTests: XCTestCase {

    func testWriter_prepareMessageLength() throws {
        let sut =  Writer().prepareMessageLength(appId: 1020, text: """
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
        """
        )
        XCTAssertEqual(sut, Data([
            250,
            1,
            0,
            0
        ]))
    }

    func testWriter_prepareMessageCommand() throws {
        let sut1 = Writer().prepareMessageCommand(appId: 1020, text: "Hello")
        XCTAssertEqual(sut1, Data([
            77, // M
            252, 3, // 1020
            72, 101, 108, 108, 111 // Hello
        ]))

        let sut2 = Writer().prepareMessageCommand(appId: 10, text: "Hi")
        XCTAssertEqual(sut2, Data([
            77, // M
            10, 0, // 10
            72, 105 // Hi
        ]))
    }

}
