//
//  Date+Extension.swift
//  SecondEnglish
//
//  Created by kimhongpil on 1/11/24.
//

import Foundation

extension Date {
    func isBetween(_ date1: Date, _ date2: Date) -> Bool {
        date1 < date2
        ? DateInterval(start: date1, end: date2).contains(self)
        : DateInterval(start: date2, end: date1).contains(self)
    }
    
    func checkOverTime(minutes:Int) -> Bool {
        let time = Int(self.timeIntervalSince(Date())) / 60
        fLog("abs(time) : \(abs(time))")
        if abs(time) > minutes {
            return true
        }
        
        return false
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func timeSinceDate(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = (earliest == self) ? fromDate : self
        
        let formatter = CommonFunction.kstDateFormatter()
        formatter.dateFormat = "yyyy"
        let current_date_string = formatter.string(from: Date())
        let post_date_string = formatter.string(from: fromDate)
        
        let components:DateComponents = Calendar.current.dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        if year >= 1 {
            return commonDate(for: fromDate)
        }
        else if month >= 1 {
            if current_date_string > post_date_string {
                return commonDate(for: fromDate)
            }
            else {
                return commonDay(for: fromDate)
            }
        }
        else  if week >= 2 {
            if current_date_string > post_date_string {
                return commonDate(for: fromDate)
            }
            else {
                return commonDay(for: fromDate)
            }
        }
        else if week >= 1 && day > 1 {
            if current_date_string > post_date_string {
                return commonDate(for: fromDate)
            }
            else {
                return commonDay(for: fromDate)
            }
        }
        else if day >= 1 && day < 8 {
            return String(format: "DaysAgo".localized, String(day))
        }
        else if hours >= 1 && hours < 24 {
            return String(format: "HoursAgo".localized, String(hours))
        }
        else if minutes >= 1 && minutes < 60 {
            return String(format: "MinutesAgo".localized, String(minutes))
        }
        else if seconds < 60 {
            return "JustNow".localized
        }
        else {
            return "JustNow".localized
        }
    }

    func commonDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        if LanguageManager.shared.getLanguageApiCode() == "ko" {
//            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "MMM d일"
        }
        else {
//            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM d"
        }
        
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    func commonDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        if LanguageManager.shared.getLanguageApiCode() == "ko" {
            //            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "yyyy년 MMM d일"
        }
        else {
//            dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.dateFormat = "MMM d, yyyy"
        }
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    func commonVideoDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    func toString(_ format:String = "MMM dd, yyyy hh:mm:ss a") -> String {
        let df = DateFormatter()
        //df.timeZone = TimeZone(abbreviation: "GMT")
        df.dateFormat = format
        
        return df.string(from: self)
    }
    
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func adding(minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
}

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
