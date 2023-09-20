//
//  TabBar.swift
//  Weather
//
//  Created by jonathan saville on 01/09/2023.
//

enum TabBarItem: Int {

    case weather
    case maps
    case warnings
    
    var title: String {
        switch self {
        case .weather: return "Weather"
        case .maps: return "Maps"
        case .warnings: return "Warnings"
        }
    }
    
    var icon: String {
        switch self {
        case .weather: return "cloud.sun"
        case .maps: return "map"
        case .warnings: return "exclamationmark.triangle"
        }
    }
    
    var order: Int {
        switch self {
        case .weather: return 0
        case .maps: return 1
        case .warnings: return 2
        }
    }
}

extension TabBarItem: Comparable {
    static func < (lhs: TabBarItem, rhs: TabBarItem) -> Bool {
        lhs.order < rhs.order
    }
}
