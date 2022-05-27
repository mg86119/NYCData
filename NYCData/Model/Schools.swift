//
//  Schools.swift
//  NYCData
//
//  Created by Murali krishna Gajula on 5/26/22.
//

import Foundation

struct Schools: Codable {
    let dbn, schoolName: String

    enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
    }
}
