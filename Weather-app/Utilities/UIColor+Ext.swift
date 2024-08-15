//
//  UIColor+Ext.swift
//  Weather-app
//
//  Created by Daniel Medina Sada on 8/15/24.
//

import UIKit

extension UIColor {
    static var defaultBackgroundColor: UIColor {
        return UIColor { $0.userInterfaceStyle == .light ? .white : .black }
    }
}
