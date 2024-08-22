//
//  Date+Extension.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

extension Date {
    
    var monthYearFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self)
    }
}
