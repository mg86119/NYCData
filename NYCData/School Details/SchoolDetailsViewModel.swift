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
        return 5
    }
 
    func cellForRow(at index: Int) -> SchoolSATScore? {
        return SchoolSATScore(rawValue: index)
    }

    func getSchoolDetails() -> SchoolDetails {
        return schoolDetails
    }
//    func schoolName() -> String {
//        return schoolDetails.schoolName
//    }
//
//    func numberOfTestTakers() -> SatPair {
//        return (name: NumberOfSATTestTakers, value: schoolDetails.numOfSatTestTakers)
//    }
//
//    func criticalReadingScore() -> SatPair {
//        return (name: CriticalReadingScore, value: schoolDetails.satCriticalReadingAvgScore)
//    }
//
//    func mathScore() -> SatPair {
//        return (name: MathAvgScore, value: schoolDetails.satMathAvgScore)
//    }
//
//    func writingScore() -> SatPair {
//        return (name: WritingAvgScore, value: schoolDetails.satWritingAvgScore)
//    }
}
