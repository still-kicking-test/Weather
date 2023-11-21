//
//  String+Ext.swift
//  Weather
//
//  Created by jonathan saville on 21/11/2023.
//

import Foundation

extension String {
    var lowercaseFirstChar: String {
        "\(prefix(1).lowercased())\(dropFirst())"
    }
}
