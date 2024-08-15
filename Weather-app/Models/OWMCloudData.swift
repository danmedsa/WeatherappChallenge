//
//  OWMCloudData.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

struct OWMCloudData: Decodable {
    var percentage: Int
    
    enum CodingKeys: String, CodingKey {
        case percentage = "all"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        percentage = try container.decode(Int.self, forKey: .percentage)
    }
}
