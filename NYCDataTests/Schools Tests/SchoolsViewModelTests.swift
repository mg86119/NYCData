//
//  SchoolsViewModelTests.swift
//  NYCDataTests
//
//  Created by Murali krishna Gajula on 5/27/22.
//

import XCTest
@testable import NYCData

/// For time being, I am only writing unit test cases for `SchoolsViewModel`
/// But given more time, I can write unit tests to cover 80% of view model
/// and model classes
class SchoolsViewModelTests: XCTestCase {
    var viewModel: SchoolsViewModel?

    override func setUpWithError() throws {
        viewModel = SchoolsViewModel(delegate: self)
        viewModel?.useMockData = true
    }

    override func tearDownWithError() throws {
        viewModel?.useMockData = false
        viewModel = nil
    }

    func testGetSchools() {
        viewModel?.getSchools()
        XCTAssertEqual(viewModel?.lastNetworkCall, .schools)
        XCTAssertNotNil(viewModel?.numberOfSchools())
        XCTAssertEqual(viewModel?.numberOfSchools(), 1)
        XCTAssertEqual(viewModel?.schoolName(for: 0), "Clinton School Writers & Artists, M.S. 260")
        XCTAssertEqual(viewModel?.selectedDBN(for: 0), "02M260")
    }

    func testGetSchoolDetails() {
        viewModel?.getSchoolsDetails(dbn: "01M292")
        XCTAssertEqual(viewModel?.lastNetworkCall, .schoolDetails)
        XCTAssertEqual(viewModel?.areSchoolsDetailsLoaded(), true)
        let details = viewModel?.selectedSchoolDetails(dbn: "01M292")
        XCTAssertNotNil(details)
        XCTAssertEqual(details?.schoolName, "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES")
        XCTAssertEqual(details?.numOfSatTestTakers, "29")
        XCTAssertEqual(details?.satWritingAvgScore, "363")
        XCTAssertEqual(details?.satCriticalReadingAvgScore, "355")
        XCTAssertEqual(details?.satMathAvgScore, "404")
    }
}

// MARK: - SchoolsViewModelDelegate
extension SchoolsViewModelTests: SchoolsViewModelDelegate {
    func getSchoolsCallSuccess() {}
    
    func getSchoolsCallFailure(_ error: String) {}
    
    func getSchoolsDetailsCallSuccess(dbn: String) {}
    
    func getSchoolsDetailsCallFailure(_ error: String, dbn: String) {}
}
