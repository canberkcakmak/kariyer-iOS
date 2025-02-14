//
//  DateHelper.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 14.02.2025.
//

import Foundation

struct DateHelper {
    static func formatDate(
        _ dateString: String,
        inputFormat: String = "yyyy-MM-dd",
        outputFormat: String = "dd MMMM yyyy",
        locale: String = "tr_TR"
    ) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = Locale(identifier: locale)
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}
