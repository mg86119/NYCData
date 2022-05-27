//
//  SchoolsViewModel.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

protocol SchoolsViewModelDelegate: AnyObject {
    func isSucess()
    func isError(_ error: String)
}

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
