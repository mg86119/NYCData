//
//  SchoolsViewModel.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

class SchoolsViewModel {
    var schoolsCall: Networking<Schools>?
    func getSchools() {
        
    }

    func numberOfSchools() -> Int {
        return 1
    }

    func schoolName(for row: Int) -> String {
        return "School"
    }
}
