//
//  Bundle+Ext.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation

extension Bundle {
    static var owmApi: APIData? {
        guard let fileURL = Bundle.main.url(forResource: "OWM-API", withExtension: "plist"),
              let contents = try? Data(contentsOf: fileURL),
              let apiData = try? PropertyListDecoder().decode(APIData.self, from: contents)
        else { return nil }
        return apiData
    }
}
