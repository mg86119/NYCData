//
//  SchoolsViewModel.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

/// Protocol for controller to know when to reload the table view or show error
protocol SchoolsViewModelDelegate: AnyObject {
    func isSucess()
    func isError(_ error: String)
}

/// View model for Schools view controller
/// Ideally I want to have all the networking end points in one single file but due to time conerns
/// I have added the end piont in this class itself
class SchoolsViewModel {
    private let SchoolsURL = "https://data.cityofnewyork.us/resource/s3k6-pzi2.json"

    private var schoolsCall: Networking<[Schools]>?
    private var schools: [String]?

    weak var delegate: SchoolsViewModelDelegate?

    // MARK: - Initializer
    init(delegate: SchoolsViewModelDelegate) {
        self.delegate = delegate
        schoolsCall = Networking<[Schools]>()
    }

    // MARK: - Helper methods
    func getSchools() {
        schoolsCall?.makeNetworkCall(urlString: SchoolsURL) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let schools):
                strongSelf.schools = schools.map { $0.schoolName }
                strongSelf.delegate?.isSucess()
            case .failure(let error):
                strongSelf.delegate?.isError(error.localizedDescription)
            }
        }
    }

    func numberOfSchools() -> Int {
        return schools?.count ?? 0
    }

    func schoolName(for row: Int) -> String {
        return schools?[row] ?? ""
    }
}
