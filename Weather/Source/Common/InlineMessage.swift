//
//  InlineMessage.swift
//  Weather
//
//  Created by jonathan saville on 07/11/2023.
//

import Foundation

enum InlineMessage {
    case noSummariesToDisplay
    
    var text: String {
        switch self {
        case .noSummariesToDisplay:
            return "Nothing to display.\nTap 'Edit' to add forecast locations."
        }
    }
}
