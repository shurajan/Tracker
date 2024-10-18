//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Alexander Bralnin on 07.10.2024.
//


import Foundation

extension Date {
    
    static let dateFormatter = newDateFormatter()
    static let ISODateFormatter = newISODateFormatter()
    static let shortDateFormatter = newShortDateFormatter()
    
    private static func newDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }
    
    private static func newISODateFormatter() -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        return formatter
    }
    
    private static func newShortDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"  // Формат даты "дд.ММ.гг"
        return formatter
    }
    
    var dateString: String {
        return Date.dateFormatter.string(from: self)
    }
    
    var shortDateString: String {
        return Date.shortDateFormatter.string(from: self)
    }
    var timeStampString: String {
        return Date.ISODateFormatter.string(from: self)
    }
}
