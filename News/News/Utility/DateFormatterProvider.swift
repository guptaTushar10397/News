//
//  DateFormatterProvider.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

class DateFormatterProvider {
    
    static let pubDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
