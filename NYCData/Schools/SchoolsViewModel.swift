//
//  SchoolsViewModel.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

/// Enumeration to handle retry if network call fails
enum LastNetworkCall {
    case schools
    case schoolDetails
}

/// Protocol for controller to know when to reload the table view or show error
protocol SchoolsViewModelDelegate: AnyObject {
    func getSchoolsCallSuccess()
    func getSchoolsCallFailure(_ error: String)
    func getSchoolsDetailsCallSuccess(dbn: String)
    func getSchoolsDetailsCallFailure(_ error: String, dbn: String)
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
    var lastNetworkCall: LastNetworkCall = .schools

    // MARK: - Initializer
    init(delegate: SchoolsViewModelDelegate) {
        self.delegate = delegate
        schoolsCall = Networking<[Schools]>()
        schoolsDetailsCall = Networking<[SchoolDetails]>()
    }

    // MARK: - Schools Helper methods
    func getSchools() {
        lastNetworkCall = .schools
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
        return Array(schools.values).count
    }

    func schoolName(for row: Int) -> String {
        return Array(schools.values)[row]
    }

    func selectedDBN(for row: Int) -> String {
        return Array(schools.keys)[row]
    }

    // MARK: - Schools Details Helper methods
    func getSchoolsDetails(dbn: String) {
        lastNetworkCall = .schoolDetails
        schoolsDetailsCall?.makeNetworkCall(urlString: SchoolsDetailsURL) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let schoolsDetails):
                schoolsDetails.forEach { detail in
                    strongSelf.schoolsDetails[detail.dbn] = detail
                }
                strongSelf.delegate?.getSchoolsDetailsCallSuccess(dbn: dbn)
            case .failure(let error):
                strongSelf.delegate?.getSchoolsDetailsCallFailure(error.localizedDescription, dbn: dbn)
            }
        }
    }

    func areSchoolsDetailsLoaded() -> Bool {
        return !schoolsDetails.isEmpty
    }

    func selectedSchoolDetails(dbn: String) -> SchoolDetails? {
        guard schoolsDetails[dbn] != nil else { return nil }

        let selectedSchoolDetails = schoolsDetails[dbn]
        return selectedSchoolDetails
    }
}
