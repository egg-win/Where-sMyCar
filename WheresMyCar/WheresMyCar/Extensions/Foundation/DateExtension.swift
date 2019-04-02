//
//  DateExtension.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case yyyyMMdd = "yyyy-MM-dd"
    case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
}

extension Date {
    static func date(from dateString: String, dateFormat: DateFormat) -> Date? {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = dateFormat.rawValue
        
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        return date
    }
    
    static func dateString(date: Date, from dateFormat: DateFormat) -> String {
        DateFormatter.shared.dateFormat = dateFormat.rawValue
        return DateFormatter.shared.string(from: date)
    }
    
    static func currentDateString(from dateFormat: DateFormat = .yyyyMMddHHmmss) -> String {
        return Date.dateString(date: Date(), from: dateFormat)
    }
    
    static func currentDateTimeIntervalSince1970() -> TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    static func transformDateString(_ dateString: String, from oldDateFormat: DateFormat, to newDateFormat: DateFormat) -> String? {
        let dateFormatter = DateFormatter.shared
        dateFormatter.dateFormat = oldDateFormat.rawValue
        
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        dateFormatter.dateFormat = newDateFormat.rawValue
        
        return dateFormatter.string(from: date)
    }
}
