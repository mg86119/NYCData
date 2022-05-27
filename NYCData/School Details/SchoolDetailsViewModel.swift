//
//  SchoolDetailsViewModel.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

class SchoolDetailsViewModel {
    private var schoolDetails: SchoolDetails

    init(scoolDetails: SchoolDetails) {
        self.schoolDetails = scoolDetails
    }

    func numberOfRows() -> Int {
        return SchoolSATScore.allCases.count
    }
 
    func cellForRow(at index: Int) -> SchoolSATScore? {
        return SchoolSATScore(rawValue: index)
    }

    func getSchoolDetails() -> SchoolDetails {
        return schoolDetails
    }
}
