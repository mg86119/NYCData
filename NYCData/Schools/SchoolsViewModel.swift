//
//  SchoolsViewModel.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

/// Protocol for controller to know when to reload the table view or show error
protocol SchoolsViewModelDelegate: AnyObject {
    func getSchoolsCallSuccess()
    func getSchoolsCallFailure(_ error: String)
    func getSchoolsDetailsCallSuccess()
    func getSchoolsDetailsCallFailure(_ error: String)
}

/// View model for Schools view controller
/// Ideally I want to have all the networking end points in one single file but due to time conerns
/// I have added the end piont in this class itself
class SchoolsViewModel {
    private let SchoolsURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"
    private let SchoolsDetailsURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"

    private var schoolsCall: Networking<[Schools]>?
    private var schoolsDetailsCall: Networking<[SchoolDetails]>?

    private var schools = [String: String]()
    private var schoolsDetails = [String: SchoolDetails]()

    weak var delegate: SchoolsViewModelDelegate?

    // MARK: - Initializer
    init(delegate: SchoolsViewModelDelegate) {
        self.delegate = delegate
        schoolsCall = Networking<[Schools]>()
        schoolsDetailsCall = Networking<[SchoolDetails]>()
    }

    // MARK: - Schools Helper methods
    func getSchools() {
        schoolsCall?.makeNetworkCall(urlString: SchoolsURL) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let schools):
                schools.forEach { val in
                    strongSelf.schools[val.dbn] = val.schoolName
                }
                strongSelf.delegate?.getSchoolsCallSuccess()
            case .failure(let error):
                strongSelf.delegate?.getSchoolsCallFailure(error.localizedDescription)
            }
        }
    }

    func numberOfSchools() -> Int {
        return schools.values.count
    }

    func schoolName(for row: Int) -> String {
        return Array(schools.values)[row]
    }

    // MARK: - Schools Details Helper methods
    func getSchoolsDetails() {
        schoolsDetailsCall?.makeNetworkCall(urlString: SchoolsDetailsURL) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let schoolsDetails):
                schoolsDetails.forEach { detail in
                    strongSelf.schoolsDetails[detail.dbn] = detail
                }
                strongSelf.delegate?.getSchoolsDetailsCallSuccess()
            case .failure(let error):
                strongSelf.delegate?.getSchoolsDetailsCallFailure(error.localizedDescription)
            }
        }
    }

    func areSchoolsDetailsLoaded() -> Bool {
        return !schoolsDetails.isEmpty
    }

    func selectedSchoolDetails() -> SchoolDetails {
        return SchoolDetails(dbn: "test", schoolName: "test", numOfSatTestTakers: "test", satCriticalReadingAvgScore: "test", satMathAvgScore: "test", satWritingAvgScore: "test")
    }
}
