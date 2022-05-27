//
//  SchoolDetailsTests.swift
//  NYCDataTests
//
//  Created by Murali krishna Gajula on 5/27/22.
//

import XCTest
@testable import NYCData

class SchoolSATScoreTests: XCTestCase {
    var satScore: SchoolSATScore?
    var schoolDetails: SchoolDetails?

    override func setUpWithError() throws {
        schoolDetails = SchoolDetails(dbn: "01M292",
                                      schoolName: "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES",
                                      numOfSatTestTakers: "29",
                                      satCriticalReadingAvgScore: "355",
                                      satMathAvgScore: "404",
                                      satWritingAvgScore: "363")
    }

    override func tearDownWithError() throws {
        schoolDetails = nil
    }

    func testSchoolName() {
        satScore = .name
        XCTAssertEqual(satScore?.description, "School Name")
        /// Using force cast `!` as i know that value exists
        XCTAssertEqual(satScore?.getValue(details: schoolDetails!), "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES")
    }

    func testTakers() {
        satScore = .numberOfTestMakers
        XCTAssertEqual(satScore?.description, "Number of SAT Test Takers")
        /// Using force cast `!` as i know that value exists
        XCTAssertEqual(satScore?.getValue(details: schoolDetails!), "29")
    }

    func testMathScore() {
        satScore = .mathScore
        XCTAssertEqual(satScore?.description, "Math Average Score")
        /// Using force cast `!` as i know that value exists
        XCTAssertEqual(satScore?.getValue(details: schoolDetails!), "404")
    }

    func testCriticalReading() {
        satScore = .criticalReading
        XCTAssertEqual(satScore?.description, "Critical Reading Average Score")
        /// Using force cast `!` as i know that value exists
        XCTAssertEqual(satScore?.getValue(details: schoolDetails!), "355")
    }

    func testWritingScore() {
        satScore = .writingScore
        XCTAssertEqual(satScore?.description, "Writig Average Score")
        /// Using force cast `!` as i know that value exists
        XCTAssertEqual(satScore?.getValue(details: schoolDetails!), "363")
    }
}
