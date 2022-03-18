//
//  ResponseReaderTests.swift
//  SpaceBeaverTests
//
//  Created by Dmytro Kholodov on 12.03.2022.
//

import XCTest
@testable import SpaceBeaver

class ResponseReaderTests: XCTestCase {

    func testParseRawResponse_Undefined() throws {
        let result = ResponseReader().parse(line: "XLL")
        XCTAssertEqual(result, .undefined)
    }

    func testParseRawResponse_Error() throws {
        let sut = ResponseReader().parse(line: "ERROR: DeviceID not configured")
        XCTAssertEqual(sut, .error(text: "DeviceID not configured"))
    }

    func testParseRawResponse_msgId() throws {
        let sut1 = ResponseReader().parse(line: "MSGID: 101")
        XCTAssertEqual(sut1, .msgSent(messageId: 101))
    }

    func testParseRawResponse_PhoneId() throws {
        let sut1 = ResponseReader().parse(line: "PHONEID: AB3432D")
        XCTAssertEqual(sut1, .phone(id: "AB3432D"))
    }

    func testParseRawResponse_Ready() throws {
        let sut = ResponseReader().parse(line: "READY")
        XCTAssertEqual(sut, .ready)
    }

    func testParseRawResponse_message() throws {
        let base64Str = CommandBuilder().makeProtoBufAsBase64(text: "Hello world", from: "1-500-000-0000")
        let response = ResponseReader().parse(line: "MSG 123 \(base64Str)")
        XCTAssertEqual(response, .message(appId: 123, text: "Hello world", from: "1-500-000-0000"))
    }

    func testParseRawResponse_ack() throws {
        let response = ResponseReader().parse(line: "ACK 123")
        XCTAssertEqual(response, .ack(messageId: 123))
    }
}
