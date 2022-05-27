//
//  SchoolSATScore.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/27/22.
//

import Foundation

enum SchoolSATScore: Int, CaseIterable, CustomStringConvertible {
    case name = 0
    case numberOfTestMakers, criticalReading, mathScore, writingScore

    var description: String {
        switch self {
        case .name:
            return "School Name"
        case .numberOfTestMakers:
            return "Number of SAT Test Takers"
        case .criticalReading:
            return "Critical Reading Average Score"
        case .mathScore:
            return "Math Average Score"
        case .writingScore:
            return "Writig Average Score"
        }
    }

    func getValue(details: SchoolDetails) -> String {
        switch self {
        case .name:
            return details.schoolName
        case .numberOfTestMakers:
            return details.numOfSatTestTakers
        case .criticalReading:
            return details.satCriticalReadingAvgScore
        case .mathScore:
            return details.satMathAvgScore
        case .writingScore:
            return details.satWritingAvgScore
        }
    }
}
