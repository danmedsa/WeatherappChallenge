//
//  UserDefaults+Ext.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import Foundation


protocol UserDefaulting {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaulting {}
