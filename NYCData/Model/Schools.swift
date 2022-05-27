//
//  Schools.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

/// Schools data
/// I just have declared whatever I need (not all the data types)
/// If given more time, I want to add all the required types
struct Schools: Codable {
    let dbn, schoolName: String

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
    }
}
