//
//  CommunicationTests.swift
//  SpaceBeaverTests
//
//  Created by Dmytro Kholodov on 12.03.2022.
//

import XCTest
@testable import SpaceBeaver

class CommunicationTests: XCTestCase {

    func testParseRawResponse_Undefined() throws {
        let result = Reader().parse(line: "XLL")
        XCTAssertEqual(result, .undefined)
    }

    func testParseRawResponse_Error() throws {
        let sut = Reader().parse(line: "ERROR: DeviceID not configured")
        XCTAssertEqual(sut, .error(text: "DeviceID not configured"))
    }

    func testParseRawResponse_msgId() throws {
        let sut1 = Reader().parse(line: "MSGID: 101")
        XCTAssertEqual(sut1, .msgSent(messageId: 101))
    }

    func testParseRawResponse_PhoneId() throws {
        let sut1 = Reader().parse(line: "PHONEID: AB3432D")
        XCTAssertEqual(sut1, .phone(id: "AB3432D"))
    }

    func testParseRawResponse_Ready() throws {
        let sut = Reader().parse(line: "READY")
        XCTAssertEqual(sut, .ready)
    }

    func testParseRawResponse_message() throws {
        let sut1 = Reader().parse(line: "MSG 123 Hello world")
        XCTAssertEqual(sut1, .message(appId: 123, text: "Hello world"))

        let sut2 = Reader().parse(line: "MSG 1 Hi!")
        XCTAssertEqual(sut2, .message(appId: 1, text: "Hi!"))

        let sut3 = Reader().parse(line: "MSG1Hi!")
        XCTAssertEqual(sut3, .undefined)

        let sut4 = Reader().parse(line: "MSG 100")
        XCTAssertEqual(sut4, .undefined)
    }

    func testParseRawResponse_ack() throws {
        let sut1 = Reader().parse(line: "ACK 505")
        XCTAssertEqual(sut1, .ack(messageId: 505))

        let sut2 = Reader().parse(line: "ACK 1 Hi!")
        XCTAssertEqual(sut2, .undefined)

        let sut3 = Reader().parse(line: "MSG1")
        XCTAssertEqual(sut3, .undefined)
    }
}
