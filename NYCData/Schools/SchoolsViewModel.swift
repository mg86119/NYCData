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
    private var filteredSchools = [String: String]()
    private var schoolsDetails = [String: SchoolDetails]()
 
    weak var delegate: SchoolsViewModelDelegate?
    var lastNetworkCall: LastNetworkCall = .schools

    /// This is for unit tests and can be used for offline data
    var useMockData: Bool = false

    // MARK: - Initializer
    init(delegate: SchoolsViewModelDelegate) {
        self.delegate = delegate
        schoolsCall = Networking<[Schools]>()
        schoolsDetailsCall = Networking<[SchoolDetails]>()
    }

    // MARK: - Schools Helper methods
    func getSchools() {
        // set last network call
        lastNetworkCall = .schools

        // mock data
        guard !useMockData else {
            if let schls = getMockSchools() {
                schls.forEach { val in
                    schools[val.dbn] = val.schoolName
                }
            }
            return
        }

        // actual network call
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
        return Array(filteredSchools.values).count
    }

    func schoolName(for row: Int) -> String {
        return Array(filteredSchools.values)[row]
    }

    func selectedDBN(for row: Int) -> String {
        return Array(filteredSchools.keys)[row]
    }

    func getAllSchools() -> [String: String] {
        return schools
    }

    func setFilteredSchools(schools: [String: String]) {
        filteredSchools = schools
    }

    func appendFilteredSchool(school: (key: String, value: String)) {
        filteredSchools[school.key] = school.value
    }

    // MARK: - Schools Details Helper methods
    func getSchoolsDetails(dbn: String) {
        // set last network call
        lastNetworkCall = .schoolDetails

        // mock data
        guard !useMockData else {
            if let schls = getMockSchoolDetails() {
                schls.forEach { detail in
                    schoolsDetails[detail.dbn] = detail
                }
            }
            return
        }

        // actual network call
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

// MARK: - Mock Data Setup
extension SchoolsViewModel {
    func getMockSchools() -> [Schools]? {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: "Schools", withExtension: "json") else {
            return nil
        }

        do {
            let json = try Data(contentsOf: url)
            let schools = try JSONDecoder().decode([Schools].self, from: json)
            return schools
        } catch _ {
            /// Print or log the error  for trouble shooting purpose
            return nil
        }
    }

    func getMockSchoolDetails() -> [SchoolDetails]? {
        let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource: "SchoolDetails", withExtension: "json") else {
            return nil
        }

        do {
            let json = try Data(contentsOf: url)
            let schoolDetails = try JSONDecoder().decode([SchoolDetails].self, from: json)
            return schoolDetails
        } catch _ {
            /// Print or log the error  for trouble shooting purpose
            return nil
        }
    }
}
