//
//  CommandWriterTests.swift
//  SpaceBeaverTests
//
//  Created by Dmytro Kholodov on 14.03.2022.
//

import XCTest
@testable import SpaceBeaver

class CommandWriterTests: XCTestCase {

    func testWriter_prepareMessageLength() throws {
        let sut =  CommandBuilder().prepareMessageLength(text: """
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
            SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests SpaceBeaverTests
        """,
        receipient: "1-500-000-0000"
        )
        XCTAssertEqual(sut.header, Data([
            15,
            2,
            0,
            0
        ]))
    }

    func testWriter_prepareMessageCommand() throws {
        let data = CommandBuilder().prepareMessageCommand(text: "Hello", to: "1-500-000-0000")

        let protoBuf = CommandBuilder().makeProtoBuf(text: "Hello", to: "1-500-000-0000")
        var expectedData = Data([
            77, // M
            252, 3, // 1020
        ])
        expectedData.append(protoBuf)
        XCTAssertEqual(data, expectedData)
    }


    func testProto_MessageSerialization() throws {
        let data = CommandBuilder().makeProtoBuf(text: "Hi there!", to: "1-500-000-0000")
        let sut = ResponseReader().readProto(source: data)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut!.text, "Hi there!")
        XCTAssertEqual(sut!.from, "1-500-000-0000")
    }
}
